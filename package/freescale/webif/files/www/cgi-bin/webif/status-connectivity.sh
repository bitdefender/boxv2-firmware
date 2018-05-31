#!/usr/bin/webif-page
<?
#
#
. /usr/lib/webif/webif.sh

uci_load network
uci_load asterisk
uci_load wireless
uci_load bridge

config_get wan_proto wan proto
wan_ifname="undefined"
[ "$wan_proto" = "dhcp" -o "$wan_proto" = "static" ] && wan_ifname="eth0"
[ "$wan_proto" = "pppoe" ] && wan_ifname="pppoe-wan"
wan_config=$(ifconfig -a 2>&1 | grep -A 7 "$wan_ifname[[:space:]]")
[ -n "$wan_config" ] && {
#  wan_ifname="pppoe-wan"
#  wan_config="inet addr:1.1.1.1  P-t-P:1.1.1.2  Mask:255.255.255.255"
  [ "$wan_ifname" = "eth0" ] && {
    wan_ip_addr=$(echo "$wan_config" | grep "inet addr" | cut -d: -f 2 | sed s/Bcast//g)
    wan_gateway=$(ip route show 0.0.0.0/0  | cut -d\  -f3)
  }
  [ "$wan_ifname" = "pppoe-wan" ] && {
    wan_ip_addr=$(echo "$wan_config" | grep "inet addr" | cut -d: -f 2 | sed s/P-t-P//g)
    wan_gateway=$(echo "$wan_config" | grep "inet addr" | cut -d: -f 3 | sed s/Mask//g)
#    wan_gateway=$(ip route show 0.0.0.0/0  | cut -d\  -f3)
  }
  wan_netmask=$(echo "$wan_config" | grep "Mask" | cut -d'M' -f 2 | cut -d':' -f 2)
#  wan_mac_addr=$(echo "$wan_config" | grep "HWaddr" | cut -d'H' -f 2 | cut -d' ' -f 2)
  wan_mac_addr=$(ubus call network.device status "{ \"name\": \"$wan_ifname\" }" | grep macaddr | cut -d':' -f 2,3,4,5,6,7 | tr -d "\"" | tr -d ",")
  wan_connected=$(ethtool eth0 | awk ' /Link detected/ { print $3}')
} 
nat_enable=`uci get nat.general.nat`
[ "$nat_enable" = "enable" ] && nat_enable="Enabled"
[ "$nat_enable" = "disable" ] && nat_enable="Disabled"
#config_get bridge_status general wan
wan_bridged="No"
#[ "$bridge_status" = "1" ] && wan_bridged="Yes"
config_get wan_if_name wan ifname
brctl_info=$(brctl show | grep -w "$wan_if_name")
[ -n "$brctl_info" ] && wan_bridged="Yes"
dns_servers=$(awk ' /nameserver/ {print $2}' /etc/ppp/resolv.conf 2> /dev/null)
dns_servers1=$(awk ' /nameserver/ {print $2}' /etc/resolv.conf 2> /dev/null | sed s/127.0.0.1//g)
dns_servers="$dns_servers $dns_servers1"
i=0
dns_srv=""
for temp in $dns_servers; do
  if [ $i != 0 ] ; then
    dns_srv="$dns_srv<b>,</b> $temp"
  else
    dns_srv="$temp" 
  fi 
  i=`expr $i + 1` 
done
                  

lan_config=$(ifconfig -a 2>&1 | grep -A 7 "$CONFIG_lan_ifname[[:space:]]")
[ -n "$lan_config" ] && {
  lan_ip_addr=$(echo "$lan_config" | grep "inet addr" | cut -d: -f 2 | sed s/Bcast//g)
  lan_netmask=$(echo "$lan_config" | grep "Mask" | cut -d'M' -f 2 | cut -d':' -f 2)
  lan_mac_addr=$(echo "$lan_config" | grep "HWaddr" | cut -d'H' -f 2 | cut -d' ' -f 2)
} 
#config_get bridge_status general lan
lan_bridged="No"
lan_dhcp_server_status="Disabled"
#[ "$bridge_status" = "1" ] && lan_bridged="Yes"
config_get lan_if_name lan ifname
brctl_info=$(brctl show | grep -w "$lan_if_name")
if [ -n "$brctl_info" ]; then
  lan_bridged="Yes"
  brctl_info=$(echo "$brctl_info" | cut -c 4- | cut -f1)
  brctl_info=$(uci get dhcp.${brctl_info}.enabled)
  [ "$brctl_info" = "1" ] && lan_dhcp_server_status="Enabled"
#[ "$lan_bridged" = "Yes" ] && {
#  dhcp_server_pid=$(pidof dnsmasq)
#  [ -n "$dhcp_server_pid" ] && {
#  dhcp_server_config=$(cat /proc/${dhcp_server_pid}/cmdline grep lan)
else 
  dhcp_server_config=$(cat /var/etc/dnsmasq.conf | grep dhcp-range | grep "=lan,")
  [ -n "$dhcp_server_config" ] && lan_dhcp_server_status="Enabled"
fi
#  }
#  [ -n "$dhcp_server_config" ] && lan_dhcp_server_status="Enabled"

#config_get wifi_found general found
wifi_found=0
wifi_text=""
config_get radio0_found   general radio0_found
[ "$radio0_found" = "1" ] && wifi_found=1
config_get radio1_found   general radio1_found
[ "$radio1_found" = "1" ] && wifi_found=1
config_get radio2_found   general radio2_found
[ "$radio2_found" = "1" ] && wifi_found=1

[ "$wifi_found" -gt 0 ] && {
#  config_get wifi_type general type
#  wifi_ifname=$wifi_type
#  [ "$wifi_type" = "wifi0" ] && wifi_ifname="ath0"
#  wifi_config=$(ifconfig $wifi_ifname 2>&1 | grep -A 7 "$wifi_ifname[[:space:]]")
#  [ -n "$wifi_config" ] && {
#    wifi_ip_addr=$(echo "$wifi_config" | grep "inet addr" | cut -d: -f 2 | sed s/Bcast//g)
#    wifi_netmask=$(echo "$wifi_config" | grep "Mask" | cut -d'M' -f 2 | cut -d':' -f 2)
#    wifi_mac_addr=$(echo "$wifi_config" | grep "HWaddr" | cut -d'H' -f 2 | cut -d' ' -f 2)
#  }
#  config_get wifi_card_type $wifi_type type
#  config_get bridge_status general wifi
#  [ "$bridge_status" = "1" ] && wifi_bridged="Yes"
#  [ "$bridge_status" = "0" ] && {
  for vap_nw in vap0 vap1 vap2 vap3 vap4 vap5 vap6 vap7; do
    iface=$(uci get ${vap_nw}.${vap_nw}.interface)
    [ -n "$iface" ] && {
      wifi_config=""
      wifi_bridged="No"                                                                        
      wifi_dhcp_server_status="Disabled"
      wifi_ip_addr=$(ifconfig "$iface" 2>/dev/null | grep "inet addr" | cut -d: -f 2 | sed s/Bcast//g)
      wifi_netmask=$(ifconfig "$iface" 2>/dev/null | grep "Mask" | cut -d'M' -f 2 | cut -d':' -f 2)
      wifi_mac_addr=$(ifconfig "$iface" 2>/dev/null | grep "HWaddr" | cut -d'H' -f 2 | cut -d' ' -f 2)
      wifi_config="$wifi_config $iface:$wifi_ip_addr/$wifi_netmask-$wifi_mac_addr "
      brctl_info=$(brctl show | grep -w "$iface")
      if [ -n "$brctl_info" ]; then
        wifi_bridged="Yes"
        brctl_info=$(echo "$brctl_info" | cut -c 4- | cut -f1)
        brctl_info=$(uci get dhcp.${brctl_info}.enabled)
        [ "$brctl_info" = "1" ] && wifi_dhcp_server_status="Enabled"
      else
        dhcp_server_config=$(cat /var/etc/dnsmasq.conf | grep dhcp-range | grep "=${vap_nw},")
        [ -n "$dhcp_server_config" ] && wifi_dhcp_server_status="Enabled"
      fi
      wifi_text="$wifi_text <table width=\"96%\" summary=\"Settings\">
                      <tr>
                        <td width=\"40%\" class=\"odd\"><span class=\"odd_status\">Network Configuration</span><a href=\"network-wlan.sh\"><img src=\"../../images/configure_new.gif\" width=\"12px\" height=\"13px\" alt=\"configure\" title=\"configure\" /></a></td>
                        <td width=\"60%\" class=\"tr_bg\">${wifi_config}</td>
                      </tr>
                      <tr>
                        <td width=\"40%\" class=\"odd\"><span class=\"odd_status\">DHCP Server</span><a href=\"network-dhcpiface.sh\"><img src=\"../../images/configure_new.gif\" width=\"12px\" height=\"13px\" alt=\"configure\" title=\"configure\" /></a></td>
                        <td width=\"60%\" class=\"tr_bg\"> ${wifi_dhcp_server_status} </td>
                      </tr>
                      <tr>
                        <td width=\"40%\" class=\"odd\"><span class=\"odd_status\">Bridged</span><a href=\"network-bridge.sh\"><img src=\"../../images/configure_new.gif\" width=\"12px\" height=\"13px\" alt=\"configure\" title=\"configure\" /></a></td>
                        <td width=\"60%\" class=\"tr_bg\"> ${wifi_bridged} </td>
                      </tr>
                    </table>
                    <p><br></p>"
    }
  done
#    dhcp_server_config=$(ps ax | grep dnsmasq | grep $wifi_ifname)
#    [ -n "$dhcp_server_config" ] && wifi_dhcp_server_status="Enabled"
#  }
}
	wifi_text="<div class=\"status_block\">
    <div class=\"settings\">
         <a href=\"network-wlan.sh\"><a href=\"network-wlan.sh\"><h3><strong>Wifi:</strong></h3></a>
             <div class=\"status_wifi\">
				<div style=\"height:100px;overflow:auto;\"> 
                	$wifi_text
				</div>
             </div>
          <div class=\"clearfix\">&nbsp;</div>
    </div>
</div>"

telephony_div=""
telephony_present=$(grep "##WEBIF:category:Telephony" /www/cgi-bin/webif/.categories)
if [ -n "$telephony_present" ]; then
  count=`uci get asterisk.general.analogphones`
  i=1
  while [ $i -le $count ]
  do
    config_get analog_name analog$i name
    config_get pot${i}_number analog$i number
    i=`expr $i + 1`
  done
  telephony_div="<div class=\"status_block\">
	<div class=\"settings\">
		 <a href=\"asterisk-extension.sh\"><h3><strong>Voice:</strong></h3></a>
			  <div class=\"status_voice\">
					<table width=\"96%\" summary=\"Settings\">
					  <tr>
						<td width=\"40%\" class=\"odd\"><span class=\"odd_status\">Pots1</span><a href=\"asterisk-extension.sh\"><img src=\"../../images/configure_new.gif\" width=\"12px\" height=\"13px\" alt=\"configure\" title=\"configure\" /></a></td>
						<td width=\"60%\" class=\"tr_bg\"><${pot1_number}></td>
					  </tr>
					  <tr>
						<td width=\"40%\" class=\"odd\"><span class=\"odd_status\">Pots2</span><a href=\"asterisk-extension.sh\"><img src=\"../../images/configure_new.gif\" width=\"12px\" height=\"13px\" alt=\"configure\" title=\"configure\" /></a></td>
						<td width=\"60%\" class=\"tr_bg\"><${pot2_number}></td>
					  </tr>
					  <tr>
						<td width=\"40%\" class=\"odd\"><span class=\"odd_status\">Pots3</span><a href=\"asterisk-extension.sh\"><img src=\"../../images/configure_new.gif\" width=\"12px\" height=\"13px\" alt=\"configure\" title=\"configure\" /></a></td>
						<td width=\"60%\" class=\"tr_bg\"><${pot3_number}></td>
					  </tr>
					  <tr>
						<td width=\"40%\" class=\"odd\"><span class=\"odd_status\">Pots4</span><a href=\"asterisk-extension.sh\"><img src=\"../../images/configure_new.gif\" width=\"12px\" height=\"13px\" alt=\"configure\" title=\"configure\" /></a></td>
						<td width=\"60%\" class=\"tr_bg\"><${pot4_number}></td>
					  </tr>
					</table>
			  </div>
		  <div class=\"clearfix\">&nbsp;</div>
	</div>
  </div>"
fi

header "Status" "Connectivity" "@TR<<system_status_details#Connectivity>>" ' ' " "
?>
<div id="status_wrap">
<div class="status_block">
	<div class="settings">
		 <a href="network-wan.sh"><h3><strong>WAN:</strong></h3></a>
			  <div class="status_wan">
					<table width="96%" summary="Settings">
					  <tr>
						<td width="40%" class="odd">MAC Address</td>
						<td width="60%"  class="tr_bg"><? echo -n ${wan_mac_addr} ?></td>
					  </tr>
					  <tr>
						<td width="40%" class="odd"><span class="odd_status">IP Address</span><a href="network-wan.sh"><img src="../../images/configure_new.gif" width="12px" height="13px" alt="configure" title="configure" /></a></td>
						<td width="60%" class="tr_bg"><? echo -n ${wan_ip_addr} ?></td>
					  </tr>
					  <tr>
						<td width="40%" class="odd"><span class="odd_status">Netmask</span><a href="network-wan.sh"><img src="../../images/configure_new.gif" width="12px" height="13px" alt="configure" title="configure" /></a></td>
						<td width="60%" class="tr_bg"><? echo -n ${wan_netmask} ?></td>
					  </tr>
					  <tr>
						<td width="40%" class="odd"><span class="odd_status">Gateway</span><a href="network-wan.sh"><img src="../../images/configure_new.gif" width="12px" height="13px" alt="configure" title="configure" /></a></td>
						<td width="60%" class="tr_bg"><? echo -n ${wan_gateway} ?></td>
					  </tr>
					  <tr>
						<td width="40%" class="odd"><span class="odd_status">Connection Type</span><a href="network-wan.sh"><img src="../../images/configure_new.gif" width="12px" height="13px" alt="configure" title="configure" /></a></td>
						<td width="60%" class="tr_bg"><? echo -n ${wan_proto} ?></td>
					  </tr>
					  <tr>
						<td width="40%" class="odd"><span class="odd_status">Connected</span><a href="network-wan.sh"><img src="../../images/configure_new.gif" width="12px" height="13px" alt="configure" title="configure" /></a></td>
						<td width="60%" class="tr_bg"><? echo -n ${wan_connected} ?></td>
					  </tr>
					  <tr>
						<td width="40%" class="odd"><span class="odd_status">NAT Enabled</span><a href="network-nat.sh"><img src="../../images/configure_new.gif" width="12px" height="13px" alt="configure" title="configure" /></a></td>
						<td width="60%" class="tr_bg"><? echo -n ${nat_enable} ?></td>
					  </tr>
					  <tr>
						<td width="40%" class="odd"><span class="odd_status">DNS Servers</span><a href="network-wan.sh"><img src="../../images/configure_new.gif" width="12px" height="13px" alt="configure" title="configure" /></a></td>
						<td width="60%" class="tr_bg"><? echo -n ${dns_srv} ?></td>
					  </tr>
					  <tr>
						<td width="40%" class="odd"><span class="odd_status">Bridged</span><a href="network-bridge.sh"><img src="../../images/configure_new.gif" width="12px" height="13px" alt="configure" title="configure" /></a></td>
						<td width="60%" class="tr_bg"><? echo -n ${wan_bridged} ?></td>
					  </tr>
					</table>
			  </div>
		  <div class="clearfix">&nbsp;</div>
	</div>
</div>

<div class="status_block">
	<div class="settings">
		 <a href="network-lan.sh"><h3><strong>LAN:</strong></h3></a>
			  <div class="status_lan">
					<table width="96%" summary="Settings">
					  <tr>
						<td width="40%" class="odd">MAC Address</td>
						<td width="60%" class="tr_bg"><? echo -n ${lan_mac_addr} ?></td>
					  </tr>
					  <tr>
						<td width="40%" class="odd"><span class="odd_status">IP Address</span><a href="network-lan.sh"><img src="../../images/configure_new.gif" width="12px" height="13px" alt="configure" title="configure" /></a></td>
						<td width="60%" class="tr_bg"><? echo -n ${lan_ip_addr} ?></td>
					  </tr>
					  <tr>
						<td width="40%" class="odd"><span class="odd_status">Netmask</span><a href="network-lan.sh"><img src="../../images/configure_new.gif" width="12px" height="13px" alt="configure" title="configure" /></a></td>
						<td width="60%" class="tr_bg"><? echo -n ${lan_netmask} ?></td>
					  </tr>
					  <tr>
						<td width="40%" class="odd"><span class="odd_status">DHCP Server</span><a href="network-dhcpiface.sh"><img src="../../images/configure_new.gif" width="12px" height="13px" alt="configure" title="configure" /></a></td>
						<td width="60%" class="tr_bg"><? echo -n ${lan_dhcp_server_status} ?></td>
					  </tr>
					  <tr>
						<td width="40%" class="odd"><span class="odd_status">Bridged</span><a href="network-bridge.sh"><img src="../../images/configure_new.gif" width="12px" height="13px" alt="configure" title="configure" /></a></td>
						<td width="60%" class="tr_bg"><? echo -n ${lan_bridged} ?></td>
					  </tr>
					</table>
			  </div>
		  <div class="clearfix">&nbsp;</div>
	</div>
</div>

<? echo ${wifi_text} ?>
<? echo  ${telephony_div} ?>
</div>
<? footer ?>
<!--
##WEBIF:name:Status:100:Connectivity
-->
