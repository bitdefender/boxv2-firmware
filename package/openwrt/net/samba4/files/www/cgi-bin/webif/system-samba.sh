#!/usr/bin/webif-page
<?
. /usr/lib/webif/webif.sh

! empty "$FORM_clear" && {
FORM_username=""
FORM_wan=""
FORM_sharename=""
FORM_sharepath=""
}

! empty "$FORM_new_user" && {
	SAVED=1
users=$(awk -F: '{print $1}' /etc/passwd)
#echo "users=$users"
echo "" >/tmppasswd1
flag=0
for user in $users; do
  echo "$user " >>/tmppasswd1
  if [ "$user" = "$FORM_username" ] ; then
    flag=1
  fi
done
echo "flag=$flag " >>/tmppasswd1
equal "$flag" "0" && {
append validate_error "ERROR in user name: "$FORM_username" is not present in /etc/passwd file"
append validate_error "$N"
echo "validation failed" >>/tmppasswd1
unvalid=1
}

validate << EOF
hostname|FORM_username|@TR<<User Name>>|required|$FORM_username
string|FORM_passwd|Password|required min=5 max=512|$FORM_passwd
EOF
	equal "$?" 0 && ! equal "$unvalid" 1 && {
	userid=`uci get samba.general.usercount`
	userid=`expr $userid + 1`
	uci_add samba sambauser smbusr$userid
	uci_set samba smbusr$userid name "$FORM_username"
	uci_set samba smbusr$userid password "$FORM_passwd"
	uci_set samba general usercount "$userid"
	#userid=`uci get samba_new.general.usercount`
	#userid=`expr $userid + 1`
	#uci_add samba_new sambauser smbusr$userid
	#ruleid=`uci get nat_new.general.rules_count`
	#ruleid=`expr $ruleid + 1`
	#uci_add nat_new nat rule$ruleid
	#uci_set nat_new rule$ruleid new_rule "1"
	#uci_set nat_new rule$ruleid service "$FORM_service"
	#uci_set nat_new rule$ruleid wan "$FORM_wan"
	#uci_set nat_new rule$ruleid wan_ip "$FORM_wanip"
	#uci_set nat_new rule$ruleid local_ip "$FORM_localip"
	#uci_set nat_new general rules_count "$ruleid"
	}
}

! empty "$FORM_new_share" && {
	SAVED=1
validate << EOF
hostname|FORM_sharename|@TR<<Share Name>>|required|$FORM_sharename
string|FORM_sharepath|@TR<<Share Path>>|required|$FORM_sharepath
EOF
	equal "$?" 0 && {
	shareid=`uci get samba.general.sharescount`
	shareid=`expr $shareid + 1`
	uci_add samba sambashare smbshare$shareid
	uci_set samba smbshare$shareid name "$FORM_sharename"
	uci_set samba smbshare$shareid path "$FORM_sharepath"
	uci_set samba smbshare$shareid read_only "no"
	uci_set samba smbshare$shareid guest_ok "no"
	uci_set samba smbshare$shareid create_mask "0700"
	uci_set samba smbshare$shareid dir_mask "0700"
	uci_set samba general sharescount "$shareid"
	#ruleid=`uci get nat_new.general.rules_count`
	#ruleid=`expr $ruleid + 1`
	#uci_add nat_new nat rule$ruleid
	#uci_set nat_new rule$ruleid new_rule "1"
	#uci_set nat_new rule$ruleid service "$FORM_service"
	#uci_set nat_new rule$ruleid wan "$FORM_wan"
	#uci_set nat_new rule$ruleid wan_ip "$FORM_wanip"
	#uci_set nat_new rule$ruleid local_ip "$FORM_localip"
	#uci_set nat_new general rules_count "$ruleid"
	}
}

! empty "$FORM_display_user" && {
	userid=$FORM_display_user
	FORM_username=${username:-$(uci get samba.smbusr$userid.name)}
        FORM_passwd=""
}

! empty "$FORM_display_share" && {
	shareid=$FORM_display_share
	FORM_sharename=${sharename:-$(uci get samba.smbshare$shareid.name)}
	FORM_sharepath=${sharepath:-$(uci get samba.smbshare$shareid.path)}
}

! empty "$FORM_save_user" && {
        SAVED=1
validate <<EOF
hostname|FORM_username|@TR<<User Name>>|required|$FORM_username
string|FORM_passwd|Password|required min=5 max=512|$FORM_passwd
EOF
	equal "$?" 0 && {
	uci_set samba smbusr$FORM_userid name "$FORM_username"
	uci_set samba smbusr$FORM_userid password "$FORM_passwd"
	}
}

! empty "$FORM_save_share" && {
        SAVED=1
validate <<EOF
hostname|FORM_sharename|@TR<<Share Name>>|required|$FORM_sharename
string|FORM_sharepath|@TR<<Share Path>>|required|$FORM_sharepath
EOF
	equal "$?" 0 && {
	uci_set samba smbshare$FORM_shareid name "$FORM_sharename"
	uci_set samba smbshare$FORM_shareid path "$FORM_sharepath"
	}
}

! empty "$FORM_delete_share" && {
	sharecount=`uci get samba.general.sharescount`
	shareid=$FORM_delete_share
	uci_remove samba smbshare$shareid
	while [ "$shareid" -le "$sharecount" ]
	do
	uci_rename samba smbshare`expr $shareid + 1` smbshare$shareid
	shareid=`expr $shareid + 1`
	done
	uci_set samba general sharescount `expr $sharecount - 1`
	#ruleid=`uci get nat_new.general.rules_count`
	#ruleid=`expr $ruleid + 1`
	#uci_add nat_new nat rule$ruleid
	#uci_set nat_new rule$ruleid delete_rule "1"
	#uci_set nat_new rule$ruleid ruleid "$FORM_delete"
	#uci_set nat_new general rules_count "$ruleid"
}

! empty "$FORM_enable" && {
	uci_set samba general enable "1"
        #natstatus=`uci get nat_new.general.nat`
        #if [ "$natstatus" = "enable" -o "$natstatus" = "disable" ] ; then
	#  uci_set nat_new general nat ''
	#else
	#  uci_set nat_new general nat enable
	#fi
}

! empty "$FORM_disable" && {
	uci_set samba general enable "0"
        #natstatus=`uci get nat_new.general.nat`
        #if [ "$natstatus" = "enable" -o "$natstatus" = "disable" ] ; then
	#  uci_set nat_new general nat ''
	#else
	#  uci_set nat_new general nat disable
	#fi
}

#####################################################################
header "System" "Samba" "@TR<<Samba Configuration>>" ''
#####################################################################

! empty "$validate_error" && {
echo "<span class=\"error\">$validate_error</span>"
}

cat <<EOF
<script type="text/javascript" src="/webif.js "></script>
<script type="text/javascript">
<!--
-->
</script>
EOF

#servicecount=`uci get firewall.general.service_count`
#i=1
#while [ $i -le $servicecount ]
#do
#name=`uci get firewall.service$i.name`
#services="$services
#option|service$i|$name"
#i=`expr $i + 1`
#done

samba=`uci get samba.general.enable`
echo "<div class=\"settings\">"
echo "<th colspan=\"11\"><h3><strong>" Samba: "</strong></h3></th>"
echo "<div class=\"settings-content\">"
echo "<table style=\"width: 26%; text-align: left; font-size: 0.8em;\" border=\"0\" cellpadding=\"3\" cellspacing=\"3\" align=\"center\"><tbody>"
case $samba in
0) echo "<tr><td>Samba Disabled</td><td style=\"text-align: center;\"><a href=\"$SCRIPT_NAME?enable=1\"><img alt=\"@TR<<enable>>\" src=\"/images/enable.jpg\" title=\"@TR<<enable>>\" /></a></td></tr>";;
1) echo "<tr><td>Samba Enabled</td><td style=\"text-align: center;\"><a href=\"$SCRIPT_NAME?disable=1\"><img alt=\"@TR<<disable>>\" src=\"/images/disable.jpg\" title=\"@TR<<disable>>\" /></a></td></tr>";;
esac
echo "</tbody></table></div><div class=\"clearfix\">&nbsp;</div></div><br>"

usercount=`uci get samba.general.usercount`

echo "<div class=\"settings\">"
echo "<th colspan=\"11\"><h3><strong>" Samba Users: "</strong></h3></th>"
echo "<div class=\"settings-content-inner\">"
echo "<table style=\"width: 96%; text-align: left; font-size: 0.8em;\" border=\"0\" cellpadding=\"3\" cellspacing=\"3\" align=\"center\"><tbody>"
echo "<tr class=\"odd\"><th>User Name</th></th><th style=\"text-align: center;\">Action</th></tr>"
if [ "$usercount" = "0" ]; then
  echo "<tr class=\"tr_bg\"><td colspan=\"2\">There are no samba users</td></tr>"
fi
i=1
while [ "$i" -le "$usercount" ]
do
username=`uci get samba.smbusr$i.name`
#equal "$service" "any" && servicename=any || servicename=`uci get firewall.$service.name`
#servicename=`uci get firewall.$service.name`
#wanip=`uci get nat.rule$i.wan_ip`
#localip=`uci get nat.rule$i.local_ip`
echo "<tr class=\"tr_bg\"><td>$username</td><td style=\"text-align: center;\"><a href=\"$SCRIPT_NAME?display_user=$i\"><img alt=\"@TR<<edit>>\" src=\"/images/edit.gif\" title=\"@TR<<edit>>\" /></a></td></tr>"
i=`expr $i + 1`
done
echo "</tbody></table></div><div class=\"clearfix\">&nbsp;</div></div><br>"

empty "$FORM_display_user" && {
display_form <<EOF
onchange|modechange
start_form|@TR<<Add Samba User>>
formtag_begin|new_user|$SCRIPT_NAME
field|@TR<<User Name>>
#text|username|$FORM_username
text|username
field|@TR<<Password>>
password|passwd
#helpitem|Services List
#helptext|List of services will be taken from Security->Services list.
field||spacer1
string|<br />
submit|new_user|@TR<<Add>>
submit|clear|@TR<<Clear>>
formtag_end
end_form
EOF
}

! empty "$FORM_display_user" && {
display_form <<EOF
onchange|modechange
start_form|@TR<<Edit Samba User $FORM_display_user>>
formtag_begin|save_user|$SCRIPT_NAME
field|@TR<<User ID>>
text|userid|$FORM_display_user|||readonly
field|@TR<<User Name>>
text|username|$FORM_username|||readonly
field|@TR<<Password>>
password|passwd
#helpitem|Services List
#helptext|List of services will be taken from Security->Services list.
field||spacer1
string|<br />
submit|save_user|@TR<<Save>>
reset||@TR<<Reset>>
formtag_end
end_form
EOF
}

sharescount=`uci get samba.general.sharescount`

echo "<div class=\"settings\">"
echo "<th colspan=\"11\"><h3><strong>" Samba Shares: "</strong></h3></th>"
echo "<div class=\"settings-content-inner\">"

echo "<table style=\"width: 96%; text-align: left; font-size: 0.8em;\" border=\"0\" cellpadding=\"3\" cellspacing=\"3\" align=\"center\"><tbody>"
echo "<tr class=\"odd\"><th>Name</th><th>Path</th></th><th style=\"text-align: center;\">Actions</th></tr>"
if [ "$sharescount" = "0" ]; then
  echo "<tr class=\"tr_bg\"><td colspan=\"3\">There are no samba shares</td></tr>"
fi
i=1
while [ "$i" -le "$sharescount" ]
do
sharename=`uci get samba.smbshare$i.name`
sharepath=`uci get samba.smbshare$i.path`
#equal "$service" "any" && servicename=any || servicename=`uci get firewall.$service.name`
#servicename=`uci get firewall.$service.name`
#wanip=`uci get nat.rule$i.wan_ip`
#localip=`uci get nat.rule$i.local_ip`
echo "<tr class=\"tr_bg\"><td>$sharename</td><td>$sharepath</td><td style=\"text-align: center;\"><a href=\"$SCRIPT_NAME?display_share=$i\"><img alt=\"@TR<<edit>>\" src=\"/images/edit.gif\" title=\"@TR<<edit>>\" /></a>  <a href=\"$SCRIPT_NAME?delete_share=$i\"><img alt=\"@TR<<delete>>\" src=\"/images/x.gif\" title=\"@TR<<delete>>\" /></a></td></tr>"
i=`expr $i + 1`
done
echo "</tbody></table></div><div class=\"clearfix\">&nbsp;</div></div><br>"

empty "$FORM_display_share" && {
display_form <<EOF
onchange|modechange
start_form|@TR<<Add Samba Share>>
formtag_begin|new_share|$SCRIPT_NAME
field|@TR<<Share Name>>
#text|sharename|$FORM_sharename
text|sharename
field|@TR<<Share Path>>
#text|sharepath|$FORM_sharepath
text|sharepath
#helpitem|Services List
#helptext|List of services will be taken from Security->Services list.
field||spacer1
string|<br />
submit|new_share|@TR<<Add>>
submit|clear|@TR<<Clear>>
formtag_end
end_form
EOF
}

! empty "$FORM_display_share" && {
display_form <<EOF
onchange|modechange
start_form|@TR<<Edit Samba Share $FORM_display_share>>
formtag_begin|save_share|$SCRIPT_NAME
field|@TR<<Share ID>>
text|shareid|$FORM_display_share|||readonly
field|@TR<<Share Name>>
text|sharename|$FORM_sharename
field|@TR<<Share Path>>
text|sharepath|$FORM_sharepath
#helpitem|Services List
#helptext|List of services will be taken from Security->Services list.
field||spacer1
string|<br />
submit|save_share|@TR<<Save>>
reset||@TR<<Reset>>
formtag_end
end_form
EOF
}

footer ?>

<!--
##WEBIF:name:System:275:Samba
-->
