/*
 *  Copyright (C) 2008 Mindspeed Technologies, Inc.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

#include <linux/kernel.h>
#include <linux/version.h>
#include <linux/module.h>
#include <linux/slab.h>
#include <linux/init.h>

#include <linux/net.h>
#include <net/sock.h>
#include <linux/if.h>
#include <linux/tcp.h>
#include <linux/in.h>
#include <asm/uaccess.h>
#include <linux/file.h>
#include <linux/socket.h>
#include <linux/sockios.h>
#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,33)
#include <net/net_namespace.h>
#endif
#include <if_csmencaps.h>

#define SOL_CSM_ENCAPS		269
#define CSME_ACK_ENABLE		1
#define MAX_MSP_MSG_LEN		1500

/* we consider that msp on this interface */
#define INTERFACE		"eth1"

#define DCI_KIOC_DEV_WRITE_MSG	4

/* global csme socket structure */
struct sockaddr_csme sockaddrcsme;
struct socket *sock;
struct csme_ackopt ack_opt;

/* Target mac address */
unsigned char dev_mac[6]={0x00,0x11,0x22,0x33,0x44,0x55};
unsigned char rcv_buff[MAX_MSP_MSG_LEN];

int fppcsm_send(struct socket *sock, struct sockaddr_csme *addr, unsigned char *buf, int len)
{
	struct msghdr msg;
	struct iovec iov;
	mm_segment_t oldfs;
	int size = 0;

	if (sock->sk == NULL)
		return 0;

	iov.iov_base = buf;
	iov.iov_len = len;

	msg.msg_flags = 0;
	msg.msg_name = addr;
	msg.msg_namelen = sizeof(struct sockaddr_csme);
	msg.msg_control = NULL;
	msg.msg_controllen = 0;
	msg.msg_iov = &iov;
	msg.msg_iovlen = 1;
	msg.msg_control = NULL;

	/* this hack should be done to be abble to use sockets in kernel space */
	oldfs = get_fs();
	set_fs(KERNEL_DS);
	size = sock_sendmsg(sock, &msg, len);
	set_fs(oldfs);

	if (size < 0)
		printk(KERN_ERR "fpp_csm: fppcsm_sendmsg error: %d\n", size);

	return size;
}

int fppcsm_recv(struct socket* sock, struct sockaddr_csme * addr, unsigned char* buf, int len)
{
	struct msghdr msg;
	struct iovec iov;
	mm_segment_t oldfs;
	int size = 0;

	if (sock->sk == NULL) 
		return 0;

	iov.iov_base = buf;
	iov.iov_len = len;

	msg.msg_flags = 0;
	msg.msg_name = addr;
	msg.msg_namelen  = sizeof(struct sockaddr_csme);
	msg.msg_control = NULL;
	msg.msg_controllen = 0;
	msg.msg_iov = &iov;
	msg.msg_iovlen = 1;
	msg.msg_control = NULL;

	oldfs = get_fs();
	set_fs(KERNEL_DS);
	size = sock_recvmsg(sock, &msg, len, msg.msg_flags);
	set_fs(oldfs);

	if (size < 0)
		printk(KERN_ERR "fpp_csm: fppcsm_recv error: %d\n", size);
	
	return size;
}

int dci_kioctl(unsigned int cmd, unsigned int flag, struct sk_buff *this_skb)
{
	mm_segment_t oldfs;
	struct sockaddr_csme stSockAddr;
	int size = 0;
	int retval = -1; 

	if (cmd == DCI_KIOC_DEV_WRITE_MSG)
	{
		retval = sock_create(AF_CSME, SOCK_DGRAM, 0, &sock);
		if (retval < 0)
		{
			printk(KERN_ERR "fpp_csm: error %d creating socket.\n", retval);
			goto err;
		}

		memcpy(&stSockAddr, &sockaddrcsme, sizeof(struct sockaddr_csme));
		/* we are not in boot phase*/
		stSockAddr.scsme_flags = 0x1;

		oldfs = get_fs();
		set_fs(KERNEL_DS);
		retval = sock_setsockopt(sock, SOL_CSM_ENCAPS, CSME_ACK_ENABLE, (char *)&ack_opt, sizeof(struct csme_ackopt));
		set_fs(oldfs);

		if (retval < 0)
		{
			printk(KERN_ERR "fpp_csm: setsockopt failed %d;\n", retval);
			goto err;
		}

		stSockAddr.scsme_channelid = *(unsigned short *)this_skb->data;
		this_skb->data = skb_pull(this_skb, 2);

		size = fppcsm_send(sock, &stSockAddr, (unsigned char *)this_skb->data, this_skb->len);

		if (size < 0)
		{
			printk(KERN_ERR "fpp_csm: dci_kioctl error %d faild to send.\n", size);
			goto err_sock_release;
		}
		else	
			/* it is expected from dci to free sk_buff */
			dev_kfree_skb(this_skb);

		size = fppcsm_recv(sock, &stSockAddr, (unsigned char *)rcv_buff, MAX_MSP_MSG_LEN);

		if (size < 0) 
		{
			printk(KERN_ERR "fpp_csm: dci_kioctl error %d faild to recive.\n", size);
			goto err_sock_release;
		}

		/* we should have time between  opened and closed socket as shot as possible */
		sock_release(sock);
	}
	else 
		goto err;

	/* dci_kioctl returns 0 if success */
	return 0;

err_sock_release:
	sock_release(sock); /* we should have time between  opened and closed socket as shot as possible */
err:
	return -EINVAL;
}

static int __init gateway_init_module (void)
{
	struct net_device *dev;

	/* do nothing just prepare information for using csmencaps protocol */
	/* We do not create socket here due to have a shortest time between opened/closed socket */
	sockaddrcsme.scsme_family = AF_CSME;

	/* this is used to get index of interface (just instead of if_nametoindex("eth1"); */
#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33)
	dev = dev_get_by_name(INTERFACE);
#else
	dev = dev_get_by_name(&init_net, INTERFACE);
#endif
      
	if (!dev)
	{
		printk(KERN_ERR "fpp_csm: dev_get_by_name(%s) failed\n", INTERFACE);
		return -1;
	}

	sockaddrcsme.scsme_ifindex = dev->ifindex;
	dev_put(dev);
	memcpy(&sockaddrcsme.scsme_devmac, dev_mac, 6);
	sockaddrcsme.scsme_opcode = __constant_htons(CSME_OPCODE_CONTROL); /* the CSME_OPCODE_CONTROL must be in BE */
	memcpy(&ack_opt.scsme_devmac, &sockaddrcsme.scsme_devmac, 6);
	ack_opt.scsme_ifindex = sockaddrcsme.scsme_ifindex;
	ack_opt.ack_suppression = 0;

	return 0;
}

static void __exit gateway_cleanup_module (void)
{
	/* do nothing (opening/closing socket in implemented in dci_kioctl() */
}

EXPORT_SYMBOL (dci_kioctl);

module_init (gateway_init_module);
module_exit (gateway_cleanup_module);
