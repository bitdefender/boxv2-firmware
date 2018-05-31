#include <linux/version.h>
#include <linux/netdevice.h>
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/skbuff.h>
#include <linux/byteorder/generic.h>	/*  ntohs(X) */
#include <linux/if_ether.h>		/*  ETH_P_IP, IP packet*/

#define ETH_P_CSM_ENCAPS 0x889B		/* CSMEncap packet */

static char *control_interface= "eth1"; 
static char *phy_interface= "eth0"; 
module_param(phy_interface, charp, 0);
MODULE_PARM_DESC(phy_interface, "Select the physical interface that receives CSM_encaps packet (LAN, or WAN)");

static char *host_macaddress_string = "00:11:22:33:44:55";
module_param(host_macaddress_string, charp, 0);
MODULE_PARM_DESC(host_macaddress_string, "sets the host mac address");

static char *support_ip = "no";
module_param(support_ip, charp, 0);
MODULE_PARM_DESC(support_ip, "allows additiolally to handle IP packets");

static char msp_macaddress[ETH_ALEN]= {0x00, 0x11, 0x22, 0x33, 0x44, 0x55};
static char ctrl_macaddress[ETH_ALEN];
static char phy_macaddress[ETH_ALEN];
static char host_macaddress[ETH_ALEN];


/**
 *  csme_bridge -
 *
 *
 */
#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,14)
int csme_bridge(struct sk_buff *skb, struct net_device *dev, struct packet_type *pt, struct net_device *orig_dev)
#else
int csme_bridge(struct sk_buff *skb, struct net_device *dev, struct packet_type *pt)
#endif
{
	struct ethhdr *eth_hdr;
	unsigned short protocol;
		
	if ((skb = skb_share_check(skb, GFP_ATOMIC)) == NULL)
	{
		printk("CSME: skb_share_check == NULL\n");
                goto out;
	}
	if( (strcmp(dev->name,phy_interface) != 0) && (strcmp(dev->name,control_interface) != 0) )
	{	
		printk("CSME: Unknown interface\n");
		goto drop;
	}
	
	//forward
	eth_hdr = (struct ethhdr *) skb_push(skb, ETH_HLEN);//eth_hdr(skb);
	protocol = ntohs (eth_hdr->h_proto);
#if 0
	printk("CSME source mac: %x:%x:%x:%x:%x:%x\n",eth_hdr->h_source[0],eth_hdr->h_source[1],eth_hdr->h_source[2],eth_hdr->h_source[3],eth_hdr->h_source[4],eth_hdr->h_source[5]);
	printk("CSME destination mac: %x:%x:%x:%x:%x:%x\n",eth_hdr->h_dest[0],eth_hdr->h_dest[1],eth_hdr->h_dest[2],eth_hdr->h_dest[3],eth_hdr->h_dest[4],eth_hdr->h_dest[5]);
#endif
	if(strcmp(dev->name,phy_interface) == 0)
	{				
		if (ETH_P_CSM_ENCAPS == protocol)
		{
			//struct ethhdr *eth = (struct ethhdr *)skb_push(skb, ETH_HLEN);
#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33)
 			struct net_device *dest_dev = dev_get_by_name(control_interface);
#else
			struct net_device *dest_dev = dev_get_by_name(&init_net, control_interface);
#endif
			memcpy(eth_hdr->h_source, ctrl_macaddress, ETH_ALEN);
			memcpy(eth_hdr->h_dest, msp_macaddress, ETH_ALEN);
#if 0
			printk("CSME Host --> MSP\n");
			printk("CSME new source mac: %x:%x:%x:%x:%x:%x\n",eth_hdr->h_source[0],eth_hdr->h_source[1],eth_hdr->h_source[2],eth_hdr->h_source[3],eth_hdr->h_source[4],eth_hdr->h_source[5]);
			printk("CSME new destination mac: %x:%x:%x:%x:%x:%x\n\n",eth_hdr->h_dest[0],eth_hdr->h_dest[1],eth_hdr->h_dest[2],eth_hdr->h_dest[3],eth_hdr->h_dest[4],eth_hdr->h_dest[5]);
#endif
			//dest_dev->hard_start_xmit(skb,dest_dev);
			skb->dev = dest_dev;
			dev_queue_xmit(skb);
		}
	}
	
	if(strcmp(dev->name,control_interface) == 0)
	{
		if ((ETH_P_CSM_ENCAPS == protocol) || (ETH_P_IP == protocol))
		{
#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33)
 			struct net_device *dest_dev = dev_get_by_name(phy_interface);
#else
			struct net_device *dest_dev = dev_get_by_name(&init_net, phy_interface);
#endif
			memcpy(eth_hdr->h_source, phy_macaddress, ETH_ALEN);
			memcpy(eth_hdr->h_dest, host_macaddress, ETH_ALEN);
#if 0
			printk("CSME MSP --> Host (%x)\n",protocol);
			printk("CSME new source mac: %x:%x:%x:%x:%x:%x\n",eth_hdr->h_source[0],eth_hdr->h_source[1],eth_hdr->h_source[2],eth_hdr->h_source[3],eth_hdr->h_source[4],eth_hdr->h_source[5]);
			printk("CSME new destination mac: %x:%x:%x:%x:%x:%x\n\n",eth_hdr->h_dest[0],eth_hdr->h_dest[1],eth_hdr->h_dest[2],eth_hdr->h_dest[3],eth_hdr->h_dest[4],eth_hdr->h_dest[5]);
#endif
			//dest_dev->hard_start_xmit(skb,dest_dev);
			skb->dev = dest_dev;
			dev_queue_xmit(skb);
		}
	}

	return NET_RX_SUCCESS;

drop:
	kfree_skb(skb);

out:
	return NET_RX_DROP;
}

struct packet_type csm_encaps_pt = {
	.type = __constant_htons(ETH_P_CSM_ENCAPS),
	.func = csme_bridge,
};

struct packet_type eth_pt = {
	.type = __constant_htons(ETH_P_IP),
	.func = csme_bridge,
};

int csme_bridge_init(void)
{
	struct net_device *orig_dev;
	int index =0;
	char *pchar;

	printk("csme_intercept_init\n");
	//get ctrl interface mac address
#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33)
 	orig_dev = dev_get_by_name(control_interface);
#else
	orig_dev = dev_get_by_name(&init_net, control_interface);
#endif
	if(orig_dev)
	{
		memcpy(ctrl_macaddress,orig_dev->dev_addr,ETH_ALEN);
	}
	else
	{
		printk("Error getting ctrl_macaddress\n");
		return -1;
	}
	//get phys interface mac address
#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33)
 	orig_dev = dev_get_by_name(phy_interface);
#else
	orig_dev = dev_get_by_name(&init_net, phy_interface);
#endif
	if(orig_dev)
	{
		memcpy(phy_macaddress,orig_dev->dev_addr,ETH_ALEN);
	}
	else
	{
		printk("Error getting phy_macaddress %s\n",phy_macaddress);
		return -1;
	}

	//get host macaddress
	printk("host_macaddress_string=%s\n",host_macaddress_string);

	index = 0;
	pchar = (unsigned char*) host_macaddress_string;
	while (pchar && (index < ETH_ALEN)) {
		if (pchar) {
			unsigned char tmp = simple_strtol(pchar, NULL, 16);
			host_macaddress[index++] = (unsigned char)tmp;
			pchar +=3;
		}
	}
	dev_add_pack(&csm_encaps_pt);
	if (strcmp(support_ip,"yes")  == 0)
	{
		dev_add_pack(&eth_pt);
		printk("IP protocol bridging enabled (MSP --> CSP)\n");
	}
	
	return 0;
}
void csme_bridge_cleanup(void)
{
	printk("csme_intercept_cleanup\n");
	dev_remove_pack(&csm_encaps_pt);
	if (strcmp(support_ip,"yes") == 0)	
		dev_remove_pack(&eth_pt);
}

int csme_bridge_init_module(void)
{
	return csme_bridge_init();
}

static void csme_bridge_cleanup_module(void)
{
	csme_bridge_cleanup();
}



module_init(csme_bridge_init_module);
module_exit(csme_bridge_cleanup_module);
