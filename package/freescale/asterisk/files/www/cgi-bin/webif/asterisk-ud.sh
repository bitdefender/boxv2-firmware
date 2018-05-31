#!/usr/bin/webif-page
<?
. "/usr/lib/webif/webif.sh"
uci_load "asterisk"

if empty "$FORM_submit"; then
	config_get FORM_dst_ipaddr ud dst_ipaddr
	config_get FORM_sport ud sport
	        FORM_sport=${FORM_sport:-16}
	config_get FORM_dport ud dport
	        FORM_dport=${FORM_dport:-32}
	config_get FORM_all ud all
	config_get FORM_phone1 ud phone1
	config_get FORM_phone2 ud phone2
	config_get FORM_phone3 ud phone3
	config_get FORM_phone4 ud phone4
	config_get FORM_tdm_tx ud tdm_tx
	config_get FORM_tdm_rx ud tdm_rx
	config_get FORM_spu_iopram ud spu_iopram
	config_get FORM_spu_in ud spu_in
	config_get FORM_spu_out ud spu_out
	config_get FORM_packet_tx ud packet_tx
	config_get FORM_packet_rx ud packet_rx
	config_get FORM_ud_report ud ud_report
else
        SAVED=1
validate <<EOF
ip|FORM_dst_ipaddr|@TR<<DST IP Address>>|required|$FORM_dst_ipaddr
int|FORM_sport|@TR<<Src Port>>|required|$FORM_sport
int|FORM_dport|@TR<<Dst Port>>|required|$FORM_dport
EOF

# saving lan settings
        equal "$?" 0 && {
                uci_set asterisk ud dst_ipaddr "$FORM_dst_ipaddr"
                uci_set asterisk ud sport "$FORM_sport"
                uci_set asterisk ud dport "$FORM_dport"
                uci_set asterisk ud all "$FORM_all"
                uci_set asterisk ud phone1 "$FORM_phone1"
                uci_set asterisk ud phone2 "$FORM_phone2"
                uci_set asterisk ud phone3 "$FORM_phone3"
                uci_set asterisk ud phone4 "$FORM_phone4"
                uci_set asterisk ud tdm_tx "$FORM_tdm_tx"
                uci_set asterisk ud tdm_rx "$FORM_tdm_rx"
                uci_set asterisk ud spu_iopram "$FORM_spu_iopram"
                uci_set asterisk ud spu_in "$FORM_spu_in"
                uci_set asterisk ud spu_out "$FORM_spu_out"
                uci_set asterisk ud packet_tx "$FORM_packet_tx"
                uci_set asterisk ud packet_rx "$FORM_packet_rx"
                uci_set asterisk ud ud_report "$FORM_ud_report"
		config_set ud dst_ipaddr "$FORM_dst_ipaddr"
		config_set ud sport "$FORM_sport"
		config_set ud dport "$FORM_dport"
		config_set ud all "$FORM_all"
		config_set ud phone1 "$FORM_phone1"
		config_set ud phone2 "$FORM_phone2"
		config_set ud phone3 "$FORM_phone3"
		config_set ud phone4 "$FORM_phone4"
		config_set ud tdm_tx "$FORM_tdm_tx"
		config_set ud tdm_rx "$FORM_tdm_rx"
		config_set ud spu_iopram "$FORM_spu_iopram"
		config_set ud spu_in "$FORM_spu_in"
		config_set ud spu_out "$FORM_spu_out"
		config_set ud packet_tx "$FORM_packet_tx"
		config_set ud packet_rx "$FORM_packet_rx"
		config_set ud ud_report "$FORM_ud_report"
        }
fi

header "Telephony" "Unified-Diag" "@TR<<Unified Diag Configuration>>" ' onload="modechange()" ' "$SCRIPT_NAME"

cat <<EOF
<script type="text/javascript" src="/webif.js"></script>
<script type="text/javascript">
function modechange()
{
        if('$FORM_all' == '1')
        {
                document.getElementById('phone1').disabled = true;
                document.getElementById('phone2').disabled = true;
                document.getElementById('phone3').disabled = true;
                document.getElementById('phone4').disabled = true;
        }
}
</script>
EOF

display_form <<EOF
onchange|modechange
start_form|@TR<<UD Global Information>>
field|@TR<<Dst IP Address>>
text|dst_ipaddr|$FORM_dst_ipaddr
field|@TR<<Src Port>>
text|sport|$FORM_sport
field|@TR<<Dst Port>>
text|dport|$FORM_dport
helpitem|IP-Address
helptext|Helptext IP-Address#IP Address is only one time configurable. If user reconfigure, it will be effective from next boot.
end_form

start_form|@TR<<Line Information>>
checkbox|all|$FORM_all|1|@TR<<All>>
checkbox|phone1|$FORM_phone1|1|@TR<<Pots 1>>
checkbox|phone2|$FORM_phone2|1|@TR<<Pots 2>>
checkbox|phone3|$FORM_phone3|1|@TR<<Pots 3>>
checkbox|phone4|$FORM_phone4|1|@TR<<Pots 4>>
end_form

start_form|@TR<<UD Types Information>>
field|@TR<<TDM TX>>
checkbox|tdm_tx|$FORM_tdm_tx|1
field|@TR<<TDM RX>>
checkbox|tdm_rx|$FORM_tdm_rx|1
field|@TR<<SPU I/O Parameters>>
checkbox|spu_iopram|$FORM_spu_iopram|1
field|@TR<<SPU In Streem>>
checkbox|spu_in|$FORM_spu_in|1
field|@TR<<SPU Out Streem>>
checkbox|spu_out|$FORM_spu_out|1
field|@TR<<Packet TX>>
checkbox|packet_tx|$FORM_packet_tx|1
field|@TR<<Packet RX>>
checkbox|packet_rx|$FORM_packet_rx|1
field|@TR<<UD Report>>
checkbox|ud_report|$FORM_ud_report|1
end_form
submit|save|@TR<<Save>>
EOF

footer ?>

<!--
##WEBIF:name:Telephony:500:Unified-Diag
-->
