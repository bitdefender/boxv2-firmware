#!/usr/bin/webif-page
<?
. /usr/lib/webif/webif.sh
. /etc/functions.sh
uci_load "asterisk"

if empty "$FORM_submit"; then
	config_get FORM_vm_main general vm_main
	config_get FORM_vm_operator general vm_operator
	else
	SAVED=1
validate <<EOF
int|FORM_vm_main|Voicemail Extension Number|required|$FORM_vm_main
int|FORM_vm_operator|Voicemail Operator Extension Number|required|$FORM_vm_operator
EOF
	equal "$?" 0 && {
	if [ "$FORM_vm_main" ];then
	uci_set asterisk general vm "yes"
	uci_set asterisk general vm_main "$FORM_vm_main"
	config_set general vm "yes"
	config_set general vm_main "$FORM_vm_main"
	else
	uci_set asterisk general vm "no"
	uci_set asterisk general vm_main ""
	config_set general vm "no"
	config_set general vm_main ""
	fi	
	uci_set asterisk general vm_operator "$FORM_vm_operator"
	config_set general vm_operator "$FORM_vm_operator"
	}
fi

header "Telephony" "Service Numbers" "@TR<<Voice Mail Extension>>" ' onload="modechange()" ' "$SCRIPT_NAME"

cat <<EOF
<script type="text/javascript" src="/webif.js"></script>
<script type="text/javascript">
function modechange()
{
}
</script>
EOF

display_form <<EOF
onchange|modechange
start_form|@TR<<Voicemail Retrieval Extension>>
field|@TR<<Extension Number>>|field_vm_main
text|vm_main|$FORM_vm_main
end_form
start_form|@TR<<Voicemail Operator Extension>>
field|@TR<<Extension Number>>|field_vm_main
text|vm_operator|$FORM_vm_operator
end_form
submit|save|@TR<<Save>>
EOF

footer ?>

<!--
##WEBIF:name:Telephony:200:Service Numbers
-->
