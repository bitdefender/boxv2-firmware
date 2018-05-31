#!/usr/bin/webif-page
<?
. /usr/lib/webif/webif.sh
uci_load "asterisk"

! empty "$FORM_new_conf" && {
        SAVED=1
validate_error=""
add_validate_success="n"
config_get conf_count general confcount
i=1
while [ "$i" -le "$conf_count" ]
do
  config_get conf_name conf$i name
  if [ "$conf_name" = "$FORM_name" ]; then
    append validate_error "<span class=\"error\"> Error in Conference Name: "$FORM_name" Conference Name already exist in Confrencing names</span>"
  fi
  config_get conf_number conf$i number
  config_get conf_admin_number conf$i admin_number
  if [ "$FORM_number" = "$conf_number" -o "$FORM_number" = "$conf_admin_number" ]; then
    append validate_error "<span class=\"error\"> Error in Conference Number: Conference Number "$FORM_number" already exist in the "$conf_name" </span>"
  fi
  if [ -n "$FORM_admin_number" ]; then
    if [ "$FORM_admin_number" = "$conf_number" -o "$FORM_admin_number" = "$conf_admin_number" ]; then
      append validate_error "<span class=\"error\"> Error in Admin Number: Admin Number "$FORM_admin_number" already exist in the "$conf_name" </span>"
    fi
  fi
  i=`expr $i + 1`
done
if [ "$FORM_number" = "$FORM_admin_number" ]; then
  append validate_error "<span class=\"error\"> Error in Conference and Admin Number: Conference Number and Admin Number should not be same.</span>"
fi

#BEGIN ANALOG
config_get analog_phones_count general analogphones
i=1
while [ "$i" -le "$analog_phones_count" ]
do
  config_get analog_name analog$i name
  if [ "$analog_name" = "$FORM_name" ]; then
    append validate_error "<span class=\"error\"> Error in Conference Name: "$FORM_name" Conference Name already exist in analog phones.</span>"
  fi
  config_get analog_number analog$i number
  if [ "$analog_number" = "$FORM_number" -o "$analog_number" = "$FORM_admin_number" ]; then
    if [ "$analog_number" = "$FORM_number" ]; then
      append validate_error "<span class=\"error\"> Error in Conference Number: Conference Number "$FORM_number"  already exist for the "$analog_name" analog phone </span>"
    else
      append validate_error "<span class=\"error\"> Error in Admin Number: Admin Number "$FORM_admin_number"  already exist for the "$analog_name" analog phone </span>"
    fi
  fi
  i=`expr $i + 1`
done
#END ANALOG

#BEGIN DECT
if [ -f /usr/lib/libdspg_dect.so ] ; then
  config_get dect_phones_count general dectphones
  i=1
  while [ "$i" -le "$dect_phones_count" ]
  do
    config_get dect_name dect$i name
    if [ "$dect_name" = "$FORM_name" ]; then
      append validate_error "<span class=\"error\"> Error in Conference Name: "$FORM_name" Conference Name already exist in dect phones.</span>"
    fi
    config_get dect_number dect$i number
    if [ "$dect_number" = "$FORM_number" -o "$dect_number" = "$FORM_admin_number" ]; then
      if [ "$dect_number" = "$FORM_number" ]; then
        append validate_error "<span class=\"error\"> Error in Conference Number: Conference Number "$FORM_number"  already exist for the "$dect_name" dect phone </span>"
      else
        append validate_error "<span class=\"error\"> Error in Admin Number: Admin Number "$FORM_admin_number"  already exist for the "$dect_name" dect phone </span>"
      fi
    fi
    i=`expr $i + 1`
  done
fi
#END DECT

#BEGIN FXO
config_get fxo_number fxo number
if [ -n "$fxo_number" ]; then
  config_get fxo_name fxo name
  if [ "$fxo_name" = "$FORM_name" ]; then
    append validate_error "<span class=\"error\"> Error in Conference Name: "$FORM_name" Conference Name already exist for fxo phone.</span>"
  fi
  if [ "$fxo_number" = "$FORM_number" -o "$fxo_number" = "$FORM_admin_number" ]; then
    if [ "$fxo_number" = "$FORM_number" ]; then
      append validate_error "<span class=\"error\"> Error in Conference Number: Conference Number "$FORM_number"  already exist for the "$fxo_name" fxo phone </span>"
    else
      append validate_error "<span class=\"error\"> Error in Admin Number: Admin Number "$FORM_admin_number"  already exist for the "$fxo_name" fxo phone </span>"
    fi
  fi
fi
#END FXO

#BEGIN VOIP
config_get voip_phones_count general voipphones
i=1
while [ "$i" -le "$voip_phones_count" ]
do
  config_get voip_name voip$i name
  if [ "$voip_name" = "$FORM_name" ]; then
    append validate_error "<span class=\"error\"> Error in Conference Name: "$FORM_name" Conference Name already exist in voip phones.</span>"
  fi
  config_get voip_number voip$i number
  if [ "$voip_number" = "$FORM_number" -o "$voip_number" = "$FORM_admin_number" ]; then
    if [ "$voip_number" = "$FORM_number" ]; then
      append validate_error "<span class=\"error\"> Error in Conference Number: Conference Number "$FORM_number"  already exist for the "$voip_name" voip phone </span>"
    else
      append validate_error "<span class=\"error\"> Error in Admin Number: Admin Number "$FORM_number"  already exist for the "$voip_name" voip phone </span>"
    fi
  fi
  i=`expr $i + 1`
done
#END VOIP
check=""
[ -n "$FORM_admin_number" ] && check="required"
validate <<EOF
hostname|FORM_name|@TR<<Conf Name>>|required|$FORM_name
int|FORM_number|@TR<<Conf Number>>|required|$FORM_number
int|FORM_admin_number|@TR<<Admin Number>>|$check|$FORM_admin_number
EOF
	equal "$?" 0 && empty "$validate_error" && {
	confid=`uci get asterisk.general.confcount`
	confid=`expr $confid + 1`
	uci_add asterisk asterisk conf$confid
	uci_set asterisk conf$confid name "$FORM_name"
	uci_set asterisk conf$confid number "$FORM_number"
	uci_set asterisk conf$confid admin_number "$FORM_admin_number"
	uci_set asterisk conf$confid wb "$FORM_wb"
	uci_set asterisk conf$confid user_counter "$FORM_user_counter"
	uci_set asterisk conf$confid moh "$FORM_moh"
	uci_set asterisk conf$confid join_leave_snd "$FORM_join_leave_snd"
	uci_set asterisk general confcount "$confid"
	config_set conf$confid name "$FORM_name"
	config_set conf$confid number "$FORM_number"
	config_set conf$confid admin_number "$FORM_admin_number"
	config_set conf$confid wb "$FORM_wb"
	config_set conf$confid user_counter "$FORM_user_counter"
	config_set conf$confid moh "$FORM_moh"
	config_set conf$confid join_leave_snd "$FORM_join_leave_snd"
	add_validate_success="y"
	}
	[ "$add_validate_success" = "n" ] && FORM_new_conf_no="Add New"
}

! empty "$FORM_display_conf" && {
	confid=$FORM_display_conf
	config_get FORM_name conf$confid name
	config_get FORM_number conf$confid number
	config_get FORM_admin_number conf$confid admin_number
	config_get FORM_wb conf$confid wb
	config_get FORM_user_counter conf$confid user_counter
	config_get FORM_moh conf$confid moh
	config_get FORM_join_leave_snd conf$confid join_leave_snd
}

! empty "$FORM_save_conf" && {
save_validate_success="n"
validate_error=""
conf_count=`uci get asterisk.general.confcount`  
i=1
while [ "$i" -le "$conf_count" ]
do
  if [ "$i" != "$FORM_confid" ]; then
    config_get conf_name conf$i name
    if [ "$conf_name" = "$FORM_name" ]; then
      append validate_error "<span class=\"error\"> Error in Conference Name: "$FORM_name" Conference Name already exist </span>"
    fi
    config_get conf_number conf$i number
    config_get conf_admin_number conf$i admin_number
    if [ "$FORM_number" = "$conf_number" -o "$FORM_number" = "$conf_admin_number" ]; then
      append validate_error "<span class=\"error\"> Error in Conference Number: Conference Number "$FORM_number" already exist in the "$conf_name" </span>"
    fi
    if [ -n "$FORM_admin_number" ]; then
      if [ "$FORM_admin_number" = "$conf_number" -o "$FORM_admin_number" = "$conf_admin_number" ]; then
        append validate_error "<span class=\"error\"> Error in Admin Number: Admin Number "$FORM_admin_number" already exist in the "$conf_name" </span>"
      fi
    fi
  fi
  i=`expr $i + 1`
done
if [ "$FORM_number" = "$FORM_admin_number" ]; then
  append validate_error "<span class=\"error\"> Error in Conference and Admin Number: Conference Number and Admin Number should not be same.</span>"
fi

#BEGIN ANALOG
config_get analog_phones_count general analogphones
i=1
while [ "$i" -le "$analog_phones_count" ]
do
  config_get analog_name analog$i name
  if [ "$analog_name" = "$FORM_name" ]; then
    append validate_error "<span class=\"error\"> Error in Conference Name: "$FORM_name" Conference Name already exist in analog phones.</span>"
  fi
  config_get analog_number analog$i number
  if [ "$analog_number" = "$FORM_number" -o "$analog_number" = "$FORM_admin_number" ]; then
    if [ "$analog_number" = "$FORM_number" ]; then
      append validate_error "<span class=\"error\"> Error in Conference Number: Conference Number "$FORM_number"  already exist for the "$analog_name" analog phone </span>"
    else
      append validate_error "<span class=\"error\"> Error in Admin Number: Admin Number "$FORM_admin_number"  already exist for the "$analog_name" analog phone </span>"
    fi
  fi
  i=`expr $i + 1`
done
#END ANALOG

#BEGIN DECT
if [ -f /usr/lib/libdspg_dect.so ] ; then
  config_get dect_phones_count general dectphones
  i=1
  while [ "$i" -le "$dect_phones_count" ]
  do
    config_get dect_name dect$i name
    if [ "$dect_name" = "$FORM_name" ]; then
      append validate_error "<span class=\"error\"> Error in Conference Name: "$FORM_name" Conference Name already exist in dect phones.</span>"
    fi
    config_get dect_number dect$i number
    if [ "$dect_number" = "$FORM_number" -o "$dect_number" = "$FORM_admin_number" ]; then
      if [ "$dect_number" = "$FORM_number" ]; then
        append validate_error "<span class=\"error\"> Error in Conference Number: Conference Number "$FORM_number"  already exist for the "$dect_name" dect phone </span>"
      else
        append validate_error "<span class=\"error\"> Error in Admin Number: Admin Number "$FORM_admin_number"  already exist for the "$dect_name" dect phone </span>"
      fi
    fi
    i=`expr $i + 1`
  done
fi
#END DECT

#BEGIN FXO
config_get fxo_number fxo number
if [ -n "$fxo_number" ]; then
  config_get fxo_name fxo name
  if [ "$fxo_name" = "$FORM_name" ]; then
    append validate_error "<span class=\"error\"> Error in Conference Name: "$FORM_name" Conference Name already exist for fxo phone.</span>"
  fi
  if [ "$fxo_number" = "$FORM_number" -o "$fxo_number" = "$FORM_admin_number" ]; then
    if [ "$fxo_number" = "$FORM_number" ]; then
      append validate_error "<span class=\"error\"> Error in Conference Number: Conference Number "$FORM_number"  already exist for the "$fxo_name" fxo phone </span>"
    else
      append validate_error "<span class=\"error\"> Error in Admin Number: Admin Number "$FORM_admin_number"  already exist for the "$fxo_name" fxo phone </span>"
    fi
  fi
fi
#END FXO

#BEGIN VOIP
config_get voip_phones_count general voipphones
i=1
while [ "$i" -le "$voip_phones_count" ]
do
  config_get voip_name voip$i name
  if [ "$voip_name" = "$FORM_name" ]; then
    append validate_error "<span class=\"error\"> Error in Conference Name: "$FORM_name" Conference Name already exist in voip phones.</span>"
  fi
  config_get voip_number voip$i number
  if [ "$voip_number" = "$FORM_number" -o "$voip_number" = "$FORM_admin_number" ]; then
    if [ "$voip_number" = "$FORM_number" ]; then
      append validate_error "<span class=\"error\"> Error in Conference Number: Conference Number "$FORM_number"  already exist for the "$voip_name" voip phone </span>"
    else
      append validate_error "<span class=\"error\"> Error in Admin Number: Admin Number "$FORM_admin_number"  already exist for the "$voip_name" voip phone </span>"
    fi
  fi
  i=`expr $i + 1`
done
#END VOIP
check=""
[ -n "$FORM_admin_number" ] && check="required"
validate <<EOF
hostname|FORM_name|@TR<<Conf Name>>|required|$FORM_name
int|FORM_number|@TR<<Conf Number>>|required|$FORM_number
int|FORM_admin_number|@TR<<Admin Number>>|$check|$FORM_admin_number
EOF
	equal "$?" 0 && empty "$validate_error" && {
	uci_set asterisk conf$FORM_confid name "$FORM_name"
	uci_set asterisk conf$FORM_confid number "$FORM_number"
	uci_set asterisk conf$FORM_confid admin_number "$FORM_admin_number"
	uci_set asterisk conf$FORM_confid wb "$FORM_wb"
	uci_set asterisk conf$FORM_confid user_counter "$FORM_user_counter"
	uci_set asterisk conf$FORM_confid moh "$FORM_moh"
	uci_set asterisk conf$FORM_confid join_leave_snd "$FORM_join_leave_snd"
	config_set conf$FORM_confid name "$FORM_name"
	config_set conf$FORM_confid number "$FORM_number"
	config_set conf$FORM_confid admin_number "$FORM_admin_number"
	config_set conf$FORM_confid wb "$FORM_wb"
	config_set conf$FORM_confid user_counter "$FORM_user_counter"
	config_set conf$FORM_confid moh "$FORM_moh"
	config_set conf$FORM_confid join_leave_snd "$FORM_join_leave_snd"
	save_validate_success="y"
	}
	[ "$save_validate_success" = "n" ] && FORM_display_conf=$FORM_confid
}

! empty "$FORM_delete" && {
	confcount=`uci get asterisk.general.confcount`
	confid=$FORM_delete
	uci_remove asterisk conf$confid
	while [ $confid -le $confcount ]
	do
	uci_rename asterisk conf`expr $confid + 1` conf$confid
	confid=`expr $confid + 1`
	done
	uci_set asterisk general confcount `expr $confcount - 1`
}

#####################################################################
header "Telephony" "Conferencing" "@TR<<Conferencing>>" ''
#####################################################################

! empty "$validate_error" && {
  echo "$validate_error"
}

count=`uci get asterisk.general.confcount`

echo "<div class=\"settings\">"
echo "<th colspan=\"11\"><h3><strong>" List of Conference rooms: "</strong></h3></th>"
echo "<div class=\"settings-content-inner\">"
echo "<table style=\"width: 96%; text-align: left; font-size: 0.8em;\" border=\"0\" cellpadding=\"3\" cellspacing=\"3\" align=\"center\"><tbody>"
echo "<tr class=\"odd\"><th>No.</th><th>Conference Name</th><th>Conference Number</th><th>Admin Number</th><th>Conference mixer</th><th>Options</th><th style=\"text-align: center;\">Actions</th></tr>"
i=1
while [ $i -le $count ]
do
config_get name conf$i name
config_get number conf$i number
config_get admin_number conf$i admin_number
config_get wb conf$i wb
config_get user_counter conf$i user_counter
config_get moh conf$i moh
config_get join_leave_snd conf$i join_leave_snd
[ -n "$wb" ] && wb="Wide band" || wb="Narrow band"
[ -z "$admin_number" ] && admin_number="none"
options=""
[ -n "$moh" ] && options="m"
[ -n "$user_counter" ] && {
	[ -n "$options" ] && options=$options"|"
	options=$options"c"
}
[ -n "$join_leave_snd" ] && {
	[ -n "$options" ] && options=$options"|"
	options=$options"s"
}
[ -n "$options" ] && options="[$options]"
[ -z "$options" ] && options="none"
echo "<tr class=\"tr_bg\"><td>$i</td><td>$name</td><td>$number</td><td>$admin_number</td><td>$wb</td><td>$options</td>"
echo "<td style=\"text-align: center;\"><a href=\"$SCRIPT_NAME?display_conf=$i\"><img alt=\"@TR<<edit>>\" src=\"/images/edit.gif\" title=\"@TR<<edit>>\" /></a>  <a href=\"$SCRIPT_NAME?delete=$i\"><img alt=\"@TR<<delete>>\" src=\"/images/x.gif\" title=\"@TR<<delete>>\" /></a></td></tr>"
i=`expr $i + 1`
done
echo "</tbody></table></div><div class=\"clearfix\">&nbsp;</div></div>"

display_form <<EOF
start_form
formtag_begin|new_conf_no|$SCRIPT_NAME
submit|new_conf_no| @TR<< Add New >>
formtag_end
end_form
EOF

! empty "$FORM_new_conf_no" && {

display_form <<EOF
start_form|@TR<<New Conference Number>>
formtag_begin|new_conf|$SCRIPT_NAME
field|@TR<<Conf Name>>|name
text|name|$FORM_name
field|@TR<<Conf Number>>|number
text|number|$FORM_number
field|@TR<<Admin Number>>|admin_number
text|admin_number|$FORM_admin_number
field|Wide Band mixer
checkbox|wb|$FORM_wb|enable
field|Announce user count
checkbox|user_counter|$FORM_user_counter|enable
field|Music on hold
checkbox|moh|$FORM_moh|enable
field|Join/leave sound
checkbox|join_leave_snd|$FORM_join_leave_snd|enable
field||spacer1
string|<br />
submit|new_conf|@TR<<Save>>
reset||@TR<<Reset>>
submit||@TR<<Cancel>>
formtag_end
end_form
EOF
}

! empty "$FORM_display_conf" && {

display_form <<EOF
start_form|@TR<<Edit Conference $FORM_display_conf>>
formtag_begin|save_conf|$SCRIPT_NAME
field|@TR<<Conf Serial No>>
text|confid|$FORM_display_conf|||readonly
field|@TR<<Conf Name>>|name
text|name|$FORM_name
field|@TR<<Conf Number>>|number
text|number|$FORM_number
field|@TR<<Admin Number>>|admin_number
text|admin_number|$FORM_admin_number
field|Wide Band mixer
checkbox|wb|$FORM_wb|enable
field|Announce count
checkbox|user_counter|$FORM_user_counter|enable
field|Music on hold
checkbox|moh|$FORM_moh|enable
field|Join/leave sound
checkbox|join_leave_snd|$FORM_join_leave_snd|enable
field||spacer1
string|<br />
submit|save_conf|@TR<<Save>>
reset||@TR<<Reset>>
submit||@TR<<Cancel>>
formtag_end
end_form
EOF
}

footer ?>

<!--
##WEBIF:name:Telephony:500:Conferencing
-->
