#!/usr/bin/webif-page
<?
#
#credit goes to arantius and GasFed
#
. /usr/lib/webif/webif.sh
#. /www/cgi-bin/webif/graphs-subcategories.sh

header " " " " "@TR<<Dash_board#Dashboard>>" 'onload="HideApplyClear()" ' " "
# IE (all versions) does not support the object tag with svg!
#	<object data="" width="500" height="250" type="image/svg+xml">@TR<<graphs_svg_required#This object requires the SVG support.>></object>
telephony_links=""
telephony_present=$(grep "##WEBIF:category:Telephony" /www/cgi-bin/webif/.categories)
if [ -n "$telephony_present" ]; then
  telephony_links="<a href=\"asterisk-conference.sh\"><img src=\"../../images/teleconf_dash_94px.jpg\" width=\"92px\" height=\"92px\" alt=\"Telephony conference\" title=\"Telephony conference\" /></a>
	<a href=\"asterisk-extension.sh\"><img src=\"../../images/teleext_dash_94px.jpg\" width=\"92px\" height=\"92px\" alt=\"Telephony extension\" title=\"Telephony extension\" /></a>
	<a href=\"asterisk-global.sh\"><img src=\"../../images/teleglobal_dash_94px.jpg\" width=\"92px\" height=\"92px\" alt=\"Telephony global\" title=\"Telephony global\" /></a>
	<a href=\"asterisk-servicenumbers.sh\"><img src=\"../../images/teleserv_dash_94px.jpg\" width=\"92px\" height=\"92px\" alt=\"Telephony service\" title=\"Telephony service\" /></a>"
fi
firewall_link=""
firewall_present=$(grep "##WEBIF:category:Firewall" /www/cgi-bin/webif/.categories)
if [ -n "$firewall_present" ]; then
  firewall_link="<a href=\"firewall-rules.sh\"><img src=\"../../images/firewall_dash_94px.jpg\" width=\"92px\" height=\"92px\" alt=\"firewall\" title=\"firewall\" /></a>"
fi
vpn_link=""
vpn_present=$(grep "##WEBIF:category:VPN" /www/cgi-bin/webif/.categories)
if [ -n "$vpn_present" ]; then
  vpn_link="<a href=\"vpn-ipsec.sh\"><img src=\"../../images/ipsec_dash_94px.jpg\" width=\"92px\" height=\"92px\" alt=\"ispec\" title=\"ipsec\" /></a>"
fi
qoslinks=""
qos_present=$(grep "##WEBIF:category:QoS" /www/cgi-bin/webif/.categories)
if [ -n "$qos_present" ]; then
board=`uci get webif.general.device_name`
if [ "$board" = "Mindspeed Comcerto 1000" ];then
	qoslinks="<a href=\"qos-egress.sh\"><img src=\"../../images/qosegress_dash_94px.jpg\" width=\"92px\" height=\"92px\" alt=\"QOS\" title=\"QOS-egress\" /></a><a href=\"qos-ingress.sh\"><img src=\"../../images/qosingress_dash_94px.jpg\" width=\"92px\" height=\"92px\" alt=\"QOS\" title=\"QOS-ingress\" /></a>"
else
	qoslinks="<a href=\"qos-ratelimiting.sh\"><img src=\"../../images/qosrate_dash_94px.jpg\" width=\"92px\" height=\"92px\" alt=\"QOS\" title=\"QOS-rate limiting\" /></a> <a href=\"qos-flows.sh\"><img src=\"../../images/qosflowc_dash_94px.jpg\" width=\"92px\" height=\"92px\" alt=\"QOS\" title=\"QOS-flowcontrol\" /></a>"
fi
fi
?>
<div id="dash_icons">
	<a href="network-lan.sh"><img src="../../images/lan_dash_94px.jpg" width="92px" height="92px" alt="LAN" title="LAN" /></a>
	<a href="network-vlan.sh"><img src="../../images/vlan_dash_94px.jpg" width="92px" height="92px" alt="VLAN" title="VLAN" /></a>
	<a href="network-wan.sh"><img src="../../images/wan_dash_94px.jpg" width="92px" height="92px" alt="WAN" title="WAN" /></a>
	<a href="network-wlan.sh"><img src="../../images/wifi_dash_94px.jpg" width="92px" height="92px" alt="WIFI" title="WIFI" /></a>
	<a href="network-nat.sh"><img src="../../images/nat_dash_94px.jpg" width="92px" height="92px" alt="NAT" title="NAT" /></a>
	<a href="network-bridge.sh"><img src="../../images/bridge_dash_94px.jpg" width="92px" height="92px" alt="Bridge" title="Bridge" /></a>
        <? echo  ${firewall_link} ?>
        <? echo  ${vpn_link} ?>
        <? echo  ${telephony_links} ?>
        <? echo  ${qoslinks} ?>
</div>

<? footer ?>
<!--
-->
