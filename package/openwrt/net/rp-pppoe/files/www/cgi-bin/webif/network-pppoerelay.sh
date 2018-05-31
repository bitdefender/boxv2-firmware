#!/usr/bin/webif-page
<?
. "/usr/lib/webif/webif.sh"
###################################################################
# PPPoE relay configuration page
###################################################################

uci_load pppoerelay

if empty "$FORM_submit"; then
	# initialize all defaults
	config_get FORM_pppoe_relay_enable general enable
	config_get FORM_max_sessions general max_sessions
	config_get FORM_server_lan general server_lan
	config_get FORM_server_wan general server_wan
	config_get FORM_client_lan general client_lan
	config_get FORM_client_wan general client_wan
	config_get FORM_mixed_lan general mixed_lan
	config_get FORM_mixed_wan general mixed_wan
	wififound=`uci get wireless.general.found`
	equal "$wififound" 1 && {
	  config_get FORM_server_wifi general server_wifi 
	  config_get FORM_client_wifi general client_wifi 
	  config_get FORM_mixed_wifi general mixed_wifi 
	}
#	bridge_count=`uci get bridge.general.count`
#	index=1
#	while [ $index -le "$bridge_count" ]
#	do
	brnames=$(ubus list network.interface.* | cut -d'.' -f 3 | sed "s/loopback//g" | sed "s/lan//g" | sed "s/wan//g" | sed "/^$/d")
	for bridge_name in $brnames; do
# 	  bridge_name=`uci get bridge.general.brname$index`
	  export FORM_server_br_"$bridge_name"=`uci get pppoerelay.general.server_br_$bridge_name`
	  export FORM_client_br_"$bridge_name"=`uci get pppoerelay.general.client_br_$bridge_name`
	  export FORM_mixed_br_"$bridge_name"=`uci get pppoerelay.general.mixed_br_$bridge_name`
#  	  index=`expr $index + 1`
	done

	vlan_count=`uci get vlan.general.count`
	index=1
	while [ $index -le "$vlan_count" ]
	do
  	  vlan_id=`uci get vlan.vlan$index.id`
	  net=`uci get vlan.vlan$index.net`
	  vlan_ifname=`uci get network.$net.ifname`
	  export FORM_server_vlan_"$vlan_ifname"_"$vlan_id"=`uci get pppoerelay.general.server_vlan_"$vlan_ifname"_"$vlan_id"`
	  export FORM_client_vlan_"$vlan_ifname"_"$vlan_id"=`uci get pppoerelay.general.client_vlan_"$vlan_ifname"_"$vlan_id"`
	  export FORM_mixed_vlan_"$vlan_ifname"_"$vlan_id"=`uci get pppoerelay.general.mixed_vlan_"$vlan_ifname"_"$vlan_id"`
	  echo "FORM_server_vlan_eth2_1=$FORM_server_vlan_eth2_1" >>/test
#	  config_get FORM_server_vlan_$vlan_ifname_$vlan_id" server_vlan_"$vlan_ifname"_"$vlan_id" 
#	  config_get FORM_client_vlan_"$vlan_ifname"_"$vlan_id" client_vlan_"$vlan_ifname"_"$vlan_id" 
#	  config_get FORM_mixed_vlan_"$vlan_ifname"_"$vlan_id" mixed_vlan_"$vlan_ifname"_"$vlan_id" 
  	  index=`expr $index + 1`
	done
else
unvalid=0
num_of_server_side_ifaces=0
num_of_client_side_ifaces=0
num_of_mixed_side_ifaces=0
[ "$FORM_server_lan" -eq 1 ] && num_of_server_side_ifaces=`expr $num_of_server_side_ifaces + 1`
[ "$FORM_server_wan" -eq 1 ] && num_of_server_side_ifaces=`expr $num_of_server_side_ifaces + 1`
[ "$FORM_client_lan" -eq 1 ] && num_of_client_side_ifaces=`expr $num_of_client_side_ifaces + 1`
[ "$FORM_client_wan" -eq 1 ] && num_of_client_side_ifaces=`expr $num_of_client_side_ifaces + 1`
[ "$FORM_mixed_lan" -eq 1 ] && num_of_mixed_side_ifaces=`expr $num_of_mixed_side_ifaces + 1`
[ "$FORM_mixed_wan" -eq 1 ] && num_of_mixed_side_ifaces=`expr $num_of_mixed_side_ifaces + 1`
wififound=`uci get wireless.general.found`
equal "$wififound" 1 && {
[ "$FORM_server_wifi" -eq 1 ] && num_of_server_side_ifaces=`expr $num_of_server_side_ifaces + 1`
[ "$FORM_client_wifi" -eq 1 ] && num_of_client_side_ifaces=`expr $num_of_client_side_ifaces + 1`
[ "$FORM_mixed_wifi" -eq 1 ] && num_of_mixed_side_ifaces=`expr $num_of_mixed_side_ifaces + 1`
}
#bridge_count=`uci get bridge.general.count`
#index=1
#while [ $index -le "$bridge_count" ]
#do
brnames=$(ubus list network.interface.* | cut -d'.' -f 3 | sed "s/loopback//g" | sed "s/lan//g" | sed "s/wan//g" | sed "/^$/d")
for bridge_name in $brnames; do
#	bridge_name=`uci get bridge.general.brname$index`
	eval bridge_val="\$FORM_server_br_$bridge_name"
	[ "$bridge_val" -eq 1 ] && num_of_server_side_ifaces=`expr $num_of_server_side_ifaces + 1`
	eval bridge_val="\$FORM_client_br_$bridge_name"
	[ "$bridge_val" -eq 1 ] && num_of_client_side_ifaces=`expr $num_of_client_side_ifaces + 1`
	eval bridge_val="\$FORM_mixed_br_$bridge_name"
	[ "$bridge_val" -eq 1 ] && num_of_mixed_side_ifaces=`expr $num_of_mixed_side_ifaces + 1`
#	index=`expr $index + 1`
done

vlan_count=`uci get vlan.general.count`
index=1
while [ $index -le "$vlan_count" ]
do
vlan_id=`uci get vlan.vlan$index.id`
net=`uci get vlan.vlan$index.net`
vlan_ifname=`uci get network.$net.ifname`
vlan_iface="$vlan_ifname"_"$vlan_id"
eval vlan_val="\$FORM_server_vlan_$vlan_iface"
[ "$vlan_val" -eq 1 ] &&  num_of_server_side_ifaces=`expr $num_of_server_side_ifaces + 1`
eval vlan_val="\$FORM_client_vlan_$vlan_iface"
[ "$vlan_val" -eq 1 ] &&  num_of_client_side_ifaces=`expr $num_of_client_side_ifaces + 1`
eval vlan_val="\$FORM_mixed_vlan_$vlan_iface"
[ "$vlan_val" -eq 1 ] &&  num_of_mixed_side_ifaces=`expr $num_of_mixed_side_ifaces + 1`
index=`expr $index + 1`
done
if [ $num_of_server_side_ifaces -eq 0 -a $num_of_client_side_ifaces -eq 0 -a $num_of_mixed_side_ifaces -eq 0 ] ; then
append validate_error "Please select any two side interfaces or two (Both server and client side) interfaces"
unvalid=1
elif [ $num_of_client_side_ifaces -eq 0 -a $num_of_mixed_side_ifaces -eq 0 ] ; then
append validate_error "Please select either client side or (Both server and client side) interface."
unvalid=1
elif [ $num_of_server_side_ifaces -eq 0 -a $num_of_mixed_side_ifaces -eq 0 ] ; then
append validate_error "Please select either server side or (Both server and client side) interface"
unvalid=1
elif [ $num_of_server_side_ifaces -eq 0 -a $num_of_client_side_ifaces -eq 0 -a $num_of_mixed_side_ifaces -lt 2 ] ; then
append validate_error "Please select server side or client side or another (Both server and client side) interface"
unvalid=1
fi

validate <<EOF
int|FORM_max_sessions|@TR<<Max allowed sessions>>|min=1 max=65534|$FORM_max_sessions
EOF
      equal "$?" 0 && ! equal "$unvalid" 1 && {
	uci_set pppoerelay general enable "$FORM_pppoe_relay_enable"
	uci_set pppoerelay general max_sessions "$FORM_max_sessions"
	uci_set pppoerelay general server_lan "$FORM_server_lan"
	uci_set pppoerelay general client_lan "$FORM_client_lan"
	uci_set pppoerelay general mixed_lan "$FORM_mixed_lan"
	uci_set pppoerelay general server_wan "$FORM_server_wan"
	uci_set pppoerelay general client_wan "$FORM_client_wan"
	uci_set pppoerelay general mixed_wan "$FORM_mixed_wan"
	wififound=`uci get wireless.general.found`
	equal "$wififound" 1 && {
	  uci_set pppoerelay general server_wifi "$FORM_server_wifi"
	  uci_set pppoerelay general client_wifi "$FORM_client_wifi"
	  uci_set pppoerelay general mixed_wifi "$FORM_mixed_wifi"
	}
#	bridge_count=`uci get bridge.general.count`
#	index=1
#	while [ $index -le "$bridge_count" ]
#	do
	brnames=$(ubus list network.interface.* | cut -d'.' -f 3 | sed "s/loopback//g" | sed "s/lan//g" | sed "s/wan//g" | sed "/^$/d")
	for bridge_name in $brnames; do
#  	  bridge_name=`uci get bridge.general.brname$index`
	  eval bridge_val="\$FORM_server_br_$bridge_name"
	  echo "bridge_val=$bridge_val" >>/test
	  uci_set pppoerelay general server_br_$bridge_name "$bridge_val"
	  eval bridge_val="\$FORM_client_br_$bridge_name"
	  uci_set pppoerelay general client_br_$bridge_name "$bridge_val"
	  eval bridge_val="\$FORM_mixed_br_$bridge_name"
	  uci_set pppoerelay general mixed_br_$bridge_name "$bridge_val"
#  	  index=`expr $index + 1`
	done

	vlan_count=`uci get vlan.general.count`
	index=1
	while [ $index -le "$vlan_count" ]
	do
  	  vlan_id=`uci get vlan.vlan$index.id`
	  net=`uci get vlan.vlan$index.net`
	  vlan_ifname=`uci get network.$net.ifname`
	  vlan_iface="$vlan_ifname"_"$vlan_id"
	  eval vlan_val="\$FORM_server_vlan_$vlan_iface"
	  echo "index=$index vlan_val=$vlan_val" >>/test
	  uci_set pppoerelay general server_vlan_"$vlan_ifname"_"$vlan_id" "$vlan_val"
	  eval vlan_val="\$FORM_client_vlan_$vlan_iface"
	  uci_set pppoerelay general client_vlan_"$vlan_ifname"_"$vlan_id" "$vlan_val"
	  eval vlan_val="\$FORM_mixed_vlan_$vlan_iface"
	  uci_set pppoerelay general mixed_vlan_"$vlan_ifname"_"$vlan_id" "$vlan_val"
  	  index=`expr $index + 1`
	done
      }
fi

#####################################################################
header "Network" "PPPoE-Relay" "@TR<<PPPoE Relay Configuration>>" ' onload="modechange()" ' "$SCRIPT_NAME"
#####################################################################

! empty "$validate_error" && {
echo "<span class="error">$validate_error</span>"
}

cat <<EOF
<script type="text/javascript" src="/webif.js"></script>
<script type="text/javascript">

function modechange( side, if_name, if_type )
{		
  var if_type1;
  var side1_iftype;

  if ( if_name == "lan" || if_name == "wan" || if_name == "wifi" )
  {
    if_type1="";
  }
  else
  {
    if_type1=if_type+"_"
  }
  if ( side == "server" )
  {
    side1_iftype="client_"+if_type1+if_name;
//    alert(side1_iftype);
    document.getElementsByName(side1_iftype).item(0).checked=false;
    side1_iftype="mixed_"+if_type1+if_name;
    document.getElementsByName(side1_iftype).item(0).checked=false;
  }
  else if ( side == "client" )
  {
    side1_iftype="server_"+if_type1+if_name;
    document.getElementsByName(side1_iftype).item(0).checked=false;
    side1_iftype="mixed_"+if_type1+if_name;
    document.getElementsByName(side1_iftype).item(0).checked=false;
  }
  else if ( side == "mixed" )
  {
    side1_iftype="server_"+if_type1+if_name;
    document.getElementsByName(side1_iftype).item(0).checked=false;
    side1_iftype="client_"+if_type1+if_name;
    document.getElementsByName(side1_iftype).item(0).checked=false;
  }
}
</script>
EOF

server_side_interfaces=""
wififound=`uci get wireless.general.found`
equal "$wififound" 1 && {
  server_side_interface="$server_side_interface
		    onclick|modechange('server', 'wifi')
                    checkbox|server_wifi|$FORM_server_wifi|1|Wi-Fi"
  client_side_interface="$client_side_interface
		    onclick|modechange('client', 'wifi')
                    checkbox|client_wifi|$FORM_client_wifi|1|Wi-Fi"
  mixed_side_interface="$mixed_side_interface
		    onclick|modechange('mixed', 'wifi')
                    checkbox|mixed_wifi|$FORM_mixed_wifi|1|Wi-Fi"
}
#bridge_count=`uci get bridge.general.count`
#index=1
#while [ $index -le "$bridge_count" ]
#do
brnames=$(ubus list network.interface.* | cut -d'.' -f 3 | sed "s/loopback//g" | sed "s/lan//g" | sed "s/wan//g" | sed "/^$/d")
for bridge_name in $brnames; do
#  bridge_name=`uci get bridge.general.brname$index`
  eval brval="\$FORM_server_br_$bridge_name"
  server_side_interface="$server_side_interface
                    onclick|modechange('server', '"$bridge_name"', 'br')
                    checkbox|server_br_$bridge_name|$brval|1|$bridge_name"
  eval brval="\$FORM_client_br_$bridge_name"
  client_side_interface="$client_side_interface
                    onclick|modechange('client', '"$bridge_name"', 'br')
                    checkbox|client_br_$bridge_name|$brval|1|$bridge_name"
  eval brval="\$FORM_mixed_br_$bridge_name"
  mixed_side_interface="$mixed_side_interface
                    onclick|modechange('mixed', '"$bridge_name"', 'br')
                    checkbox|mixed_br_$bridge_name|$brval|1|$bridge_name"
#  index=`expr $index + 1`
done

vlan_count=`uci get vlan.general.count`
index=1
while [ $index -le "$vlan_count" ]
do
  vlan_id=`uci get vlan.vlan$index.id`
  net=`uci get vlan.vlan$index.net`
  vlan_ifname=`uci get network.$net.ifname`
  vlanvalue=FORM_server_vlan_"$vlan_ifname"_"$vlan_id"
  eval vlanval="\$$vlanvalue"
  vlanname=server_vlan_"$vlan_ifname"_"$vlan_id"
  server_side_interface="$server_side_interface
                    onclick|modechange('server', '"$vlan_ifname"_"$vlan_id"', 'vlan')
                    checkbox|$vlanname|$vlanval|1|$vlan_ifname.$vlan_id"
  vlanvalue=FORM_client_vlan_"$vlan_ifname"_"$vlan_id"
  eval vlanval="\$$vlanvalue"
  vlanname=client_vlan_"$vlan_ifname"_"$vlan_id"
  client_side_interface="$client_side_interface
                    onclick|modechange('client', '"$vlan_ifname"_"$vlan_id"', 'vlan')
                    checkbox|$vlanname|$vlanval|1|$vlan_ifname.$vlan_id"
  vlanvalue=FORM_mixed_vlan_"$vlan_ifname"_"$vlan_id"
  eval vlanval="\$$vlanvalue"
  vlanname=mixed_vlan_"$vlan_ifname"_"$vlan_id"
  mixed_side_interface="$mixed_side_interface
                    onclick|modechange('mixed', '"$vlan_ifname"_"$vlan_id"', 'vlan')
                    checkbox|$vlanname|$vlanval|1|$vlan_ifname.$vlan_id"
#  mixed_side_interface="$mixed_side_interface
 #                   checkbox|mixed_vlan_$vlan_ifname_$vlan_id|$vlanval|1|$vlan_ifname.$vlan_id"
  index=`expr $index + 1`
done


display_form <<EOF
onclick|modechange
start_form|@TR<<PPPoE Relay>>
field|@TR<<PPPoE Relay Status>>
select|pppoe_relay_enable|$FORM_pppoe_relay_enable
option|0|@TR<<Disabled>>
option|1|@TR<<Enabled>>
field|@TR<<Server side interface>>
onclick|modechange('server', 'lan')
checkbox|server_lan|$FORM_server_lan|1|LAN
onclick|modechange('server', 'wan')
checkbox|server_wan|$FORM_server_wan|1|WAN
$server_side_interface
field|@TR<<Client side interface>>
onclick|modechange('client', 'lan')
checkbox|client_lan|$FORM_client_lan|1|LAN
onclick|modechange('client', 'wan')
checkbox|client_wan|$FORM_client_wan|1|WAN
$client_side_interface
field|@TR<<Both Server and Client side interface>>
onclick|modechange('mixed', 'lan')
checkbox|mixed_lan|$FORM_mixed_lan|1|LAN
onclick|modechange('mixed', 'wan')
checkbox|mixed_wan|$FORM_mixed_wan|1|WAN
$mixed_side_interface
field|@TR<<Max allowed sessions>>
text|max_sessions|$FORM_max_sessions
end_form
submit|save|@TR<<Save>>
EOF

footer ?>
<!--
##WEBIF:name:Network:850:PPPoE-Relay
-->
