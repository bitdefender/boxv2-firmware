#!/usr/bin/webif-page
<?
. /usr/lib/webif/webif.sh
. /etc/functions.sh
uci_load "asterisk"

if empty "$FORM_submit"; then
  	config_get FORM_enable_proxy extproxy enable_proxy
  	config_get FORM_login_name extproxy login_name
	config_get FORM_ext_pxy_pwd extproxy ext_pxy_pwd
	config_get FORM_addr_type_value extproxy addr_type
	config_get FORM_ip_addr extproxy ipaddress
	config_get FORM_domain_name extproxy domainname
	config_get FORM_sip_authentication_value extproxy sip_auth
	config_get FORM_pattern_ph_no extproxy patternphno
else
	SAVED=1
	if [ "$FORM_enable_proxy" ];then
	  login_pwd_req="required"
	  if [ "$FORM_addr_type_value" = "ipaddress" ];then
	    ip_req="required"
	    domainname_req="" 
	  else
	    ip_req=""
	    domainname_req="required" 
	  fi
	else
	  login_pwd_req=""
	  ip_req=""
	  domainname_req="" 
	fi
validate <<EOF
string|FORM_login_name|Login name|$login_pwd_req|$FORM_login_name
string|FORM_ext_pxy_pwd|Password|$login_pwd_req|$FORM_ext_pxy_pwd
ip|FORM_ip_addr|IP Address|$ip_req|$FORM_ip_addr
hostname|FORM_domain_name|Domain Name|$domainname_req|$FORM_domain_name
phpattern|FORM_pattern_ph_no|Phone pattern||$FORM_pattern_ph_no
EOF
        equal "$?" 0 && {
	  if [ "$FORM_enable_proxy" ];then
	    uci_set asterisk extproxy login_name "$FORM_login_name"
	    uci_set asterisk extproxy ext_pxy_pwd "$FORM_ext_pxy_pwd"
	    uci_set asterisk extproxy addr_type "$FORM_addr_type_value"
	    uci_set asterisk extproxy ipaddress "$FORM_ip_addr"
	    uci_set asterisk extproxy domainname "$FORM_domain_name"
	    uci_set asterisk extproxy sip_auth "$FORM_sip_authentication_value"
	    uci_set asterisk extproxy patternphno "$FORM_pattern_ph_no"
	    config_set extproxy login_name "$FORM_login_name"
	    config_set extproxy ext_pxy_pwd "$FORM_ext_pxy_pwd"
	    config_set extproxy addr_type "$FORM_addr_type_value"
	    config_set extproxy ipaddress "$FORM_ip_addr"
	    config_set extproxy domainname "$FORM_domain_name"
	    config_set extproxy sip_auth "$FORM_sip_authentication_value"
	    config_set extproxy patternphno "$FORM_pattern_ph_no"
          else
            uci_set asterisk extproxy login_name ""
            uci_set asterisk extproxy ext_pxy_pwd ""
            uci_set asterisk extproxy addr_type "ipaddress"
            uci_set asterisk extproxy ipaddress ""
            uci_set asterisk extproxy domainname ""
	    uci_set asterisk extproxy sip_auth "disable"
            uci_set asterisk extproxy patternphno ""
            config_set extproxy login_name ""
            config_set extproxy ext_pxy_pwd ""
            config_set extproxy addr_type "ipaddress"
            config_set extproxy ipaddress ""
            config_set extproxy domainname ""
	    config_set extproxy sip_auth "disable"
            config_set extproxy patternphno ""
	  fi	
	  uci_set asterisk extproxy enable_proxy "$FORM_enable_proxy"
	  config_set extproxy enable_proxy "$FORM_enable_proxy"
	}
fi

header "Telephony" "External SIP Proxy" "@TR<<External SIP Proxy Configuration>>"  ' onload="proxymodechange(1)" ' "$SCRIPT_NAME"

cat <<EOF
<script type="text/javascript" src="/webif.js"></script>
<script type="text/javascript">
<!--
function proxymodechange( load )
{
  var v ;
   
  if ( load )
  {
    if ('$FORM_enable_proxy' == 1 )
    {
      v = true;
      document.getElementById("enable_proxy_1").checked = true;
    }
    else
    {
      v = false;
      document.getElementById("enable_proxy_1").checked = false;
    }
  }
  else
  {
    v = checked('enable_proxy_1');
  }
  set_visible('field_login_name', v);
  set_visible('field_ext_pxy_pwd', v);
  set_visible('field_addr_type', v);
  set_visible('field_ip_addr_fqdn', v);
  set_visible('field_sip_authentication', v);
  set_visible('field_pattern_ph_no', v);
  if ( v )
  {
    if ( document.forms[0].addr_type_value[1].checked ) // Domain Name radio button is checked
    {
      set_visible('field_ip_addr', false);
      set_visible('field_domain_name', true);
    }
    else
    {
      set_visible('field_domain_name', false);
      set_visible('field_ip_addr', true);
    }
  }
  else
  {
    set_visible('field_ip_addr', v);
    set_visible('field_domain_name', v);
  }
}
-->
</script>
EOF

display_form <<EOF
onclick|proxymodechange(0)
start_form|@TR<<External SIP Proxy Configuration>>
checkbox|enable_proxy|$FORM_enable_proxy|1|@TR<<Connect to External SIP Proxy>>
field|@TR<<Login Name>>|field_login_name|hidden
text|login_name|$FORM_login_name
field|@TR<<Password>>|field_ext_pxy_pwd|hidden
password|ext_pxy_pwd|$FORM_ext_pxy_pwd
field|@TR<<Address Type>>|field_addr_type|hidden
radio|addr_type_value|$FORM_addr_type_value|ipaddress|@TR<<IP address>>
radio|addr_type_value|$FORM_addr_type_value|domainname|@TR<<Domain name>>
field|@TR<<IP Address>>|field_ip_addr|hidden
text|ip_addr|$FORM_ip_addr
field|@TR<<Domain name>>|field_domain_name|hidden
text|domain_name|$FORM_domain_name
field|@TR<<SIP-Authentication>>|field_sip_authentication|hidden
radio|sip_authentication_value|$FORM_sip_authentication_value|enable|@TR<<Enable>>
radio|sip_authentication_value|$FORM_sip_authentication_value|disable|@TR<<Disable>>
field|@TR<<Phone No. Pattern>>|field_pattern_ph_no|hidden
text|pattern_ph_no|$FORM_pattern_ph_no
end_form
submit|save|@TR<<Save>>
EOF

footer ?>

<!--
##WEBIF:name:Telephony:502:External SIP Proxy
-->
