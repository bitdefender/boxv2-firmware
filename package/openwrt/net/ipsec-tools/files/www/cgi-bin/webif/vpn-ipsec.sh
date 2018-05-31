#!/usr/bin/webif-page
<?
. "/usr/lib/webif/webif.sh"
###################################################################
# VPN ipsec policies configuration page
#
# Description:
#       Configures VPN ipsec policies.
#
###Load settings from the ipsec config file.
uci_load "ipsec"

! empty "$FORM_add_ipsec_policy" && {
  SAVED=1
  unvalid=0
  add_ipsec_policy_apply="n"
  if [ "$FORM_IP_version" == "ip" ] ; then
    netmask_version=netmask
  else
    netmask_version=netmask6
  fi
  count=`uci get ipsec.general.count`
  i=1
  while [ $i -le "$count" ]
  do
    polname=`uci get ipsec."ipsec$i".Name`
###### IPsec policy name duplication verification ################
    equal $polname "$FORM_policy_name" && {
      append validate_error "ERROR in Policy Name: "$FORM_policy_name" policy name already exist"
      unvalid=1
    }

    i=`expr $i + 1`
  done
  case "$FORM_local_nw" in
    "single") V_LIP="required" ;;
    "subnet") V_LIP="required"
              V_LNM="required" ;;
    *) V_LIP=""
       V_LNM="" ;;
  esac
  case "$FORM_remote_nw" in
    single) V_RIP="required" ;;
    subnet) V_RIP="required"
            V_RNM="required" ;;
    *) V_RIP=""
       V_RNM="" ;;
  esac
  case "$FORM_spi_in" in
    0x*|0X*) V_SI="required min=5"
             D_SI="hexdec" ;;
    *) V_SI="required min=256" 
       D_SI="int" ;;
  esac
  case "$FORM_spi_out" in
    0x*|0X*) V_SO="required min=5"
             D_SO="hexdec" ;;
    *) V_SO="required min=256" 
       D_SO="int" ;;
  esac
  ###min and max length in hexdec type is 2*string_type_length + 2(0x length)
  case "$FORM_encrypt_alg" in
    des-cbc) case "$FORM_key_in" in
               0x*|0X*) V_EKI="required min=18 max=18"
                        D_EKI="hexdec" ;;
               *) V_EKI="required min=8 max=8" 
                  D_EKI="string" ;;
             esac
             case "$FORM_key_out" in
               0x*|0X*) V_EKO="required min=18 max=18"
                        D_EKO="hexdec" ;;
               *) V_EKO="required min=8 max=8"
                  D_EKO="string" ;;
             esac 
           ;;
    3des-cbc) case "$FORM_key_in" in
               0x*|0X*) V_EKI="required min=50 max=50"
                        D_EKI="hexdec" 
                        str1=$(echo $FORM_key_in | cut -c 3-18)
                        str2=$(echo $FORM_key_in | cut -c 19-34)
                        str3=$(echo $FORM_key_in | cut -c 35-50)
                        equal "$str1" "$str2" && {
                          append validate_error "Invalid encryption key-in: First 8 bytes should not equal second 8 bytes"
                          unvalid=1
                        }
                        equal "$str2" "$str3" && {
                          append validate_error "Invalid encryption key-in: Second 8 bytes should not equal third 8 bytes"
                          unvalid=1
                        } ;;
               *) V_EKI="required min=24 max=24"
                  D_EKI="string" 
                  str1=$(echo $FORM_key_in | cut -c 1-8)
                  str2=$(echo $FORM_key_in | cut -c 9-16)
                  str3=$(echo $FORM_key_in | cut -c 17-24)
                  equal "$str1" "$str2" && {
                    append validate_error "Invalid encryption key-in: First 8 bytes should not equal second 8 bytes"
                    unvalid=1
                  }
                  equal "$str2" "$str3" && {
                    append validate_error "Invalid encryption key-in: Second 8 bytes should not equal third 8 bytes"
                    unvalid=1
                  } ;;
              esac
              case "$FORM_key_out" in
               0x*|0X*) V_EKO="required min=50 max=50"
                        D_EKO="hexdec" 
                        str1=$(echo $FORM_key_out | cut -c 3-18)
                        str2=$(echo $FORM_key_out | cut -c 19-34)
                        str3=$(echo $FORM_key_out | cut -c 35-50)
                        equal "$str1" "$str2" && {
                          append validate_error "Invalid encryption key-out: First 8 bytes should not equal second 8 bytes"
                          unvalid=1
                        }
                        equal "$str2" "$str3" && {
                          append validate_error "Invalid encryption key-out: Second 8 bytes should not equal third 8 bytes"
                          unvalid=1
                        } ;;
               *) V_EKO="required min=24 max=24"
                  D_EKO="string" 
                  str1=$(echo $FORM_key_out | cut -c 1-8)
                  str2=$(echo $FORM_key_out | cut -c 9-16)
                  str3=$(echo $FORM_key_out | cut -c 17-24)
                  equal "$str1" "$str2" && {
                    append validate_error "Invalid encryption key-out: First 8 bytes should not equal second 8 bytes"
                    unvalid=1
                  }
                  equal "$str2" "$str3" && {
                    append validate_error "Invalid encryption key-out: Second 8 bytes should not equal third 8 bytes"
                    unvalid=1
                  } ;;
              esac 
            ;;
    aes-128) case "$FORM_key_in" in
               0x*|0X*) V_EKI="required min=34 max=34"
                        D_EKI="hexdec" ;;
               *) V_EKI="required min=16 max=16"
                  D_EKI="string" ;;
              esac
              case "$FORM_key_out" in
               0x*|0X*) V_EKO="required min=34 max=34"
                        D_EKO="hexdec" ;;
               *) V_EKO="required min=16 max=16"
                  D_EKO="string" ;;
              esac
            ;;
     aes-192) case "$FORM_key_in" in
               0x*|0X*) V_EKI="required min=50 max=50"
                        D_EKI="hexdec" ;;
               *) V_EKI="required min=24 max=24"
                  D_EKI="string" ;;
              esac
              case "$FORM_key_out" in
               0x*|0X*) V_EKO="required min=50 max=50"
                        D_EKO="hexdec" ;;
               *) V_EKO="required min=24 max=24"
                  D_EKO="string" ;;
              esac
            ;;
     aes-256) case "$FORM_key_in" in
               0x*|0X*) V_EKI="required min=66 max=66"
                        D_EKI="hexdec" ;;
               *) V_EKI="required min=32 max=32"
                  D_EKI="string" ;;
              esac
              case "$FORM_key_out" in
               0x*|0X*) V_EKO="required min=66 max=66"
                        D_EKO="hexdec" ;;
               *) V_EKO="required min=32 max=32"
                  D_EKO="string" ;;
              esac
            ;;
    *) V_EKI="" 
       V_EKO="" 
       D_EKI="string"
       D_EKO="string" ;;
  esac
  case "$FORM_auth_alg" in
    hmac-md5) case "$FORM_auth_key_in" in
               0x*|0X*) V_AKI="required min=34 max=34"
                        D_AKI="hexdec" ;;
               *) V_AKI="required min=16 max=16" 
                  D_AKI="string";;
              esac
              case "$FORM_auth_key_out" in
               0x*|0X*) V_AKO="required min=34 max=34"
                        D_AKO="hexdec" ;;
               *) V_AKO="required min=16 max=16"
                  D_AKO="string";;
              esac
             ;;
    hmac-sha1) case "$FORM_auth_key_in" in
               0x*|0X*) V_AKI="required min=42 max=42"
                        D_AKI="hexdec" ;;
               *) V_AKI="required min=20 max=20"
                  D_AKI="string";;
              esac
              case "$FORM_auth_key_out" in
               0x*|0X*) V_AKO="required min=42 max=42"
                        D_AKO="hexdec" ;;
               *) V_AKO="required min=20 max=20"
                  D_AKO="string";;
              esac
            ;;
     hmac-sha2-256) case "$FORM_auth_key_in" in
                     0x*|0X*) V_AKI="required min=66 max=66"
                              D_AKI="hexdec" ;;
                     *) V_AKI="required min=32 max=32"
                        D_AKI="string";;
                    esac
                    case "$FORM_auth_key_out" in
                     0x*|0X*) V_AKO="required min=66 max=66"
                              D_AKO="hexdec" ;;
                     *) V_AKO="required min=32 max=32"
                        D_AKO="string";;
                    esac
                  ;;
    *) V_AKI=""
       V_AKO=""
       D_AKI="string"
       D_AKO="string" ;;
  esac
validate <<EOF
hostname|FORM_policy_name|@TR<<Policy Name>>|required|$FORM_policy_name
$FORM_IP_version|FORM_local_gw_ipaddr|@TR<<Local Gateway IP address>>|required|$FORM_local_gw_ipaddr
$FORM_IP_version|FORM_remote_gw_ipaddr|@TR<<Remote Gateway IP address>>|required|$FORM_remote_gw_ipaddr
$FORM_IP_version|FORM_local_start_ip|@TR<<Local network IP address>>|$V_LIP|$FORM_local_start_ip
$netmask_version|FORM_local_subnet_mask|@TR<<Local network subnetmask>>|$V_LNM|$FORM_local_subnet_mask
$FORM_IP_version|FORM_remote_start_ip|@TR<<Remote network IP address>>|$V_RIP|$FORM_remote_start_ip
$netmask_version|FORM_remote_subnet_mask|@TR<<Remote network subnetmask>>|$V_RNM|$FORM_remote_subnet_mask
$D_SI|FORM_spi_in|@TR<<SPI in>>|$V_SI|$FORM_spi_in
$D_SO|FORM_spi_out|@TR<<SPI out>>|$V_SO|$FORM_spi_out
$D_EKI|FORM_key_in|@TR<<Encryption key in>>|$V_EKI|$FORM_key_in
$D_EKO|FORM_key_out|@TR<<Encryption key out>>|$V_EKO|$FORM_key_out
$D_AKI|FORM_auth_key_in|@TR<<Authentication key in>>|$V_AKI|$FORM_auth_key_in
$D_AKO|FORM_auth_key_out|@TR<<Authentication key out>>|$V_AKO|$FORM_auth_key_out
EOF
  equal "$?" 0 && ! equal "$unvalid" 1 && {
    ipsecruleid=`uci get ipsec.general.count`
    ipsecruleid=`expr $ipsecruleid + 1`
    uci_add ipsec ipsec  "ipsec$ipsecruleid"
    uci_set ipsec "ipsec$ipsecruleid" Name "$FORM_policy_name"
    uci_set ipsec "ipsec$ipsecruleid" StatusEnable "1"
    uci_set ipsec "ipsec$ipsecruleid" IPVersion "$FORM_IP_version"
    uci_set ipsec "ipsec$ipsecruleid" Protocol "$FORM_protocol_type"
    uci_set ipsec "ipsec$ipsecruleid" LocalGwIp "$FORM_local_gw_ipaddr"
    uci_set ipsec "ipsec$ipsecruleid" RemoteGwIp "$FORM_remote_gw_ipaddr"
    uci_set ipsec "ipsec$ipsecruleid" LocalNw "$FORM_local_nw"
    uci_set ipsec "ipsec$ipsecruleid" RemoteNw "$FORM_remote_nw"
    uci_set ipsec "ipsec$ipsecruleid" LocalIp "$FORM_local_start_ip"
    uci_set ipsec "ipsec$ipsecruleid" LocalNetmask "$FORM_local_subnet_mask"
    uci_set ipsec "ipsec$ipsecruleid" RemoteIp "$FORM_remote_start_ip"
    uci_set ipsec "ipsec$ipsecruleid" RemoteNetmask "$FORM_remote_subnet_mask"
    uci_set ipsec "ipsec$ipsecruleid" SpiIn "$FORM_spi_in"
    uci_set ipsec "ipsec$ipsecruleid" SpiOut "$FORM_spi_out"
    if [ "$FORM_protocol_type" = "ah" ] ; then
      uci_set ipsec "ipsec$ipsecruleid" EncAlgo " "
    else
      uci_set ipsec "ipsec$ipsecruleid" EncAlgo "$FORM_encrypt_alg"
    fi
    uci_set ipsec "ipsec$ipsecruleid" EncKeyIn "$FORM_key_in"
    uci_set ipsec "ipsec$ipsecruleid" EncKeyOut "$FORM_key_out"
    uci_set ipsec "ipsec$ipsecruleid" AuthAlgo "$FORM_auth_alg"
    uci_set ipsec "ipsec$ipsecruleid" AuthKeyIn "$FORM_auth_key_in"
    uci_set ipsec "ipsec$ipsecruleid" AuthKeyOut "$FORM_auth_key_out"
    uci_set ipsec general count "$ipsecruleid"

    ipsec_newruleid=`uci get ipsec_new.general.count`
    ipsec_newruleid=`expr $ipsec_newruleid + 1`
    uci_add ipsec_new ipsec  "ipsec_new$ipsec_newruleid"
#   uci_set ipsec_new "ipsec$ipsec_newruleid" Name "$FORM_policy_name"
    uci_set ipsec_new "ipsec_new$ipsec_newruleid" NewRule "1"
    uci_set ipsec_new "ipsec_new$ipsec_newruleid" ModifyRule "0"
    uci_set ipsec_new "ipsec_new$ipsec_newruleid" DeleteRule "0"
    uci_set ipsec_new "ipsec_new$ipsec_newruleid" IPVersion "$FORM_IP_version"
    uci_set ipsec_new "ipsec_new$ipsec_newruleid" Protocol "$FORM_protocol_type"
    uci_set ipsec_new "ipsec_new$ipsec_newruleid" LocalGwIp "$FORM_local_gw_ipaddr"
    uci_set ipsec_new "ipsec_new$ipsec_newruleid" RemoteGwIp "$FORM_remote_gw_ipaddr"
    uci_set ipsec_new "ipsec_new$ipsec_newruleid" LocalNw "$FORM_local_nw"
    uci_set ipsec_new "ipsec_new$ipsec_newruleid" RemoteNw "$FORM_remote_nw"
    uci_set ipsec_new "ipsec_new$ipsec_newruleid" LocalIp "$FORM_local_start_ip"
    uci_set ipsec_new "ipsec_new$ipsec_newruleid" LocalNetmask "$FORM_local_subnet_mask"
    uci_set ipsec_new "ipsec_new$ipsec_newruleid" RemoteIp "$FORM_remote_start_ip"
    uci_set ipsec_new "ipsec_new$ipsec_newruleid" RemoteNetmask "$FORM_remote_subnet_mask"
    uci_set ipsec_new "ipsec_new$ipsec_newruleid" SpiIn "$FORM_spi_in"
    uci_set ipsec_new "ipsec_new$ipsec_newruleid" SpiOut "$FORM_spi_out"
    if [ "$FORM_protocol_type" = "ah" ] ; then
      uci_set ipsec_new "ipsec_new$ipsec_newruleid" EncAlgo " "
    else
      uci_set ipsec_new "ipsec_new$ipsec_newruleid" EncAlgo "$FORM_encrypt_alg"
    fi
    uci_set ipsec_new "ipsec_new$ipsec_newruleid" EncKeyIn "$FORM_key_in"
    uci_set ipsec_new "ipsec_new$ipsec_newruleid" EncKeyOut "$FORM_key_out"
    uci_set ipsec_new "ipsec_new$ipsec_newruleid" AuthAlgo "$FORM_auth_alg"
    uci_set ipsec_new "ipsec_new$ipsec_newruleid" AuthKeyIn "$FORM_auth_key_in"
    uci_set ipsec_new "ipsec_new$ipsec_newruleid" AuthKeyOut "$FORM_auth_key_out"
    uci_set ipsec_new general count "$ipsec_newruleid"
    add_ipsec_policy_apply="y"
   # config_set "ipsec$ipsecruleid" Name "$FORM_policy_name"
   # config_set "ipsec$ipsecruleid" Protocol "$FORM_protocol_type"
   # config_set "ipsec$ipsecruleid" RemoteGwIp "$FORM_remote_gw_ipaddr"
   # config_set "ipsec$ipsecruleid" LocalNw "$FORM_local_nw"
    #config_set "ipsec$ipsecruleid" RemoteNw "$FORM_remote_nw"
    #config_set "ipsec$ipsecruleid" LocalIp "$FORM_local_start_ip"
    #config_set "ipsec$ipsecruleid" LocalNetmask "$FORM_local_subnet_mask"
    #config_set "ipsec$ipsecruleid" RemoteIp "$FORM_remote_start_ip"
    #config_set "ipsec$ipsecruleid" RemoteNetmask "$FORM_remote_subnet_mask"
    #config_set "ipsec$ipsecruleid" SpiIn "$FORM_spi_in"
    #config_set "ipsec$ipsecruleid" SpiOut "$FORM_spi_out"
    #config_set "ipsec$ipsecruleid" EncAlgo "$FORM_encrypt_alg"
    #config_set "ipsec$ipsecruleid" EncKeyIn "$FORM_key_in"
    #config_set "ipsec$ipsecruleid" EncKeyOut "$FORM_key_out"
    #config_set "ipsec$ipsecruleid" AuthAlgo "$FORM_auth_alg"
    #config_set "ipsec$ipsecruleid" AuthKeyIn "$FORM_auth_key_in"
    #config_set "ipsec$ipsecruleid" AuthKeyOut "$FORM_auth_key_out"
    #config_set general count "$ipsecruleid"
  }
}

! empty "$FORM_display_ipsec_policy" && {
  polname="ipsec$FORM_display_ipsec_policy"
  #config_get FORM_policy_name $polname Name
  #config_get FORM_protocol_type $polname Protocol
  #config_get FORM_remote_gw_ipaddr $polname RemoteGwIp
  #config_get FORM_local_nw $polname LocalNw
  #config_get FORM_remote_nw $polname RemoteNw
  #config_get FORM_local_start_ip $polname LocalIp
  #config_get FORM_local_subnet_mask $polname LocalNetmask
  #config_get FORM_remote_start_ip $polname RemoteIp
  #config_get FORM_remote_subnet_mask $polname RemoteNetmask
  #config_get FORM_spi_in $polname SpiIn
  #config_get FORM_spi_out $polname SpiOut
  #config_get FORM_encrypt_alg $polname EncAlgo
  #config_get FORM_key_in $polname EncKeyIn
  #config_get FORM_key_out $polname EncKeyOut
  #config_get FORM_auth_alg $polname AuthAlgo
  #config_get FORM_auth_key_in $polname AuthKeyIn
  #config_get FORM_auth_key_out $polname AuthKeyOut
  FORM_policy_name=${policy_name:-$(uci get ipsec.$polname.Name)}
  FORM_status_enable=${status_enable:-$(uci get ipsec.$polname.StatusEnable)}
  FORM_IP_version=${IP_version:-$(uci get ipsec.$polname.IPVersion)}
  FORM_protocol_type=${protocol_type:-$(uci get ipsec.$polname.Protocol)}
  FORM_local_gw_ipaddr=${local_gw_ipaddr:-$(uci get ipsec.$polname.LocalGwIp)}
  FORM_remote_gw_ipaddr=${remote_gw_ipaddr:-$(uci get ipsec.$polname.RemoteGwIp)}
  FORM_local_nw=${local_nw:-$(uci get ipsec.$polname.LocalNw)}
  FORM_remote_nw=${remote_nw:-$(uci get ipsec.$polname.RemoteNw)}
  FORM_local_start_ip=${local_start_ip:-$(uci get ipsec.$polname.LocalIp)}
  FORM_local_subnet_mask=${local_subnet_mask:-$(uci get ipsec.$polname.LocalNetmask)}
  FORM_remote_start_ip=${remote_start_ip:-$(uci get ipsec.$polname.RemoteIp)}
  FORM_remote_subnet_mask=${remote_subnet_mask:-$(uci get ipsec.$polname.RemoteNetmask)}
  FORM_spi_in=${spi_in:-$(uci get ipsec.$polname.SpiIn)}
  FORM_spi_out=${spi_out:-$(uci get ipsec.$polname.SpiOut)}
  FORM_encrypt_alg=${encrypt_alg:-$(uci get ipsec.$polname.EncAlgo)}
  FORM_key_in=${key_in:-$(uci get ipsec.$polname.EncKeyIn)}
  FORM_key_out=${key_out:-$(uci get ipsec.$polname.EncKeyOut)}
  FORM_auth_alg=${auth_alg:-$(uci get ipsec.$polname.AuthAlgo)}
  FORM_auth_key_in=${auth_key_in:-$(uci get ipsec.$polname.AuthKeyIn)}
  FORM_auth_key_out=${auth_key_out:-$(uci get ipsec.$polname.AuthKeyOut)}
}

! empty "$FORM_apply_ipsec_policy" && {
    
   count=`uci get ipsec.general.count`
   i=1
   #echo "" >/test1
   while [ $i -le "$count" ]
   do
     eval checkboxvar="\$FORM_pol_status_$i"
     #echo "checkboxvar=<$checkboxvar> " >>/test1
     if [ -n "$checkboxvar" ] ; then
      #echo "enable part entered" >>/test1
      oldstatus=`uci get ipsec."ipsec$i".StatusEnable` 
      #echo "oldstatus=$oldstatus" >>/test1
      if [ "$oldstatus" = "0" ] ; then
        uci_set ipsec "ipsec$i" StatusEnable "1"

        count=`uci get ipsec.general.count`
        polname="ipsec$i"
        IP_version=`uci get ipsec.$polname.IPVersion`
        protocol=`uci get ipsec.$polname.Protocol`
        localgwip=`uci get ipsec.$polname.LocalGwIp`
        remotegwip=`uci get ipsec.$polname.RemoteGwIp`
        localnw=`uci get ipsec.$polname.LocalNw`
        remotenw=`uci get ipsec.$polname.RemoteNw`
        localip=`uci get ipsec.$polname.LocalIp`
        if [ "$localnw" = "subnet" ] ; then
          localnetmask=`uci get ipsec.$polname.LocalNetmask`
        else
          localnetmask=""
        fi
        remoteip=`uci get ipsec.$polname.RemoteIp`
        if [ "$remotenw" = "subnet" ] ; then
          remotenetmask=`uci get ipsec.$polname.RemoteNetmask`
        else
          remotenetmask=""
        fi
        spiin=`uci get ipsec.$polname.SpiIn`
        spiout=`uci get ipsec.$polname.SpiOut`
        encrypt_alg=`uci get ipsec.$polname.EncAlgo`
        if [ "$encrypt_alg" != "null" -a "$encrypt_alg" != " " ] ; then
          key_in=`uci get ipsec.$polname.EncKeyIn`
          key_out=`uci get ipsec.$polname.EncKeyOut`
        else
          key_in=""
          key_out=""
        fi
        auth_alg=`uci get ipsec.$polname.AuthAlgo`
        if [ "$auth_alg" != "null" -a "$auth_alg" != " " ] ; then
          auth_key_in=`uci get ipsec.$polname.AuthKeyIn`
          auth_key_out=`uci get ipsec.$polname.AuthKeyOut`
        else
          auth_key_in=""
          auth_key_out=""
        fi

     #   uci_set ipsec $polname StatusEnable "yes"
  
        ipsec_newruleid=`uci get ipsec_new.general.count`
        ipsec_newruleid=`expr $ipsec_newruleid + 1`
        uci_add ipsec_new ipsec  "ipsec_new$ipsec_newruleid"
        uci_set ipsec_new "ipsec_new$ipsec_newruleid" NewRule "1"
        uci_set ipsec_new "ipsec_new$ipsec_newruleid" ModifyRule "0"
        uci_set ipsec_new "ipsec_new$ipsec_newruleid" DeleteRule "0"
        uci_set ipsec_new "ipsec_new$ipsec_newruleid" IPVersion "$IP_version"
        uci_set ipsec_new "ipsec_new$ipsec_newruleid" Protocol $protocol
        uci_set ipsec_new "ipsec_new$ipsec_newruleid" LocalGwIp $localgwip
        uci_set ipsec_new "ipsec_new$ipsec_newruleid" RemoteGwIp $remotegwip
        uci_set ipsec_new "ipsec_new$ipsec_newruleid" LocalNw $localnw
        uci_set ipsec_new "ipsec_new$ipsec_newruleid" RemoteNw $remotenw
        uci_set ipsec_new "ipsec_new$ipsec_newruleid" LocalIp $localip
        uci_set ipsec_new "ipsec_new$ipsec_newruleid" RemoteIp $remoteip
        uci_set ipsec_new "ipsec_new$ipsec_newruleid" LocalNetmask $localnetmask
        uci_set ipsec_new "ipsec_new$ipsec_newruleid" RemoteNetmask $remotenetmask
        uci_set ipsec_new "ipsec_new$ipsec_newruleid" SpiIn $spiin
        uci_set ipsec_new "ipsec_new$ipsec_newruleid" SpiOut $spiout
        uci_set ipsec_new "ipsec_new$ipsec_newruleid" EncAlgo "$encrypt_alg"
        uci_set ipsec_new "ipsec_new$ipsec_newruleid" EncKeyIn "$key_in"
        uci_set ipsec_new "ipsec_new$ipsec_newruleid" EncKeyOut "$key_out"
        uci_set ipsec_new "ipsec_new$ipsec_newruleid" AuthAlgo "$auth_alg"
        uci_set ipsec_new "ipsec_new$ipsec_newruleid" AuthKeyIn "$auth_key_in"
        uci_set ipsec_new "ipsec_new$ipsec_newruleid" AuthKeyOut "$auth_key_out"
        uci_set ipsec_new general count "$ipsec_newruleid"
      fi
     else
      #echo "disable part entered" >>/test1
      oldstatus=`uci get ipsec."ipsec$i".StatusEnable` 
      #echo "oldstatus=$oldstatus" >>/test1
      if [ "$oldstatus" = "1" ] ; then
        uci_set ipsec "ipsec$i" StatusEnable "0"

        #count=`uci get ipsec.general.count`
        polname="ipsec$i"
        IP_version=`uci get ipsec.$polname.IPVersion`
        protocol=`uci get ipsec.$polname.Protocol`
        localgwip=`uci get ipsec.$polname.LocalGwIp`
        remotegwip=`uci get ipsec.$polname.RemoteGwIp`
        localnw=`uci get ipsec.$polname.LocalNw`
        remotenw=`uci get ipsec.$polname.RemoteNw`
        localip=`uci get ipsec.$polname.LocalIp`
        if [ "$localnw" = "subnet" ] ; then
          localnetmask=`uci get ipsec.$polname.LocalNetmask`
        else
          localnetmask=""
        fi
        remoteip=`uci get ipsec.$polname.RemoteIp`
        if [ "$remotenw" = "subnet" ] ; then
          remotenetmask=`uci get ipsec.$polname.RemoteNetmask`
        else
          remotenetmask=""
        fi
        spiin=`uci get ipsec.$polname.SpiIn`
        spiout=`uci get ipsec.$polname.SpiOut`
        #ipsecruleid=$FORM_disable_ipsec_policy
        #uci_set ipsec $polname StatusEnable ""
  
        ipsec_newruleid=`uci get ipsec_new.general.count`
        ipsec_newruleid=`expr $ipsec_newruleid + 1`
        uci_add ipsec_new ipsec  "ipsec_new$ipsec_newruleid"
        uci_set ipsec_new "ipsec_new$ipsec_newruleid" NewRule "0"
        uci_set ipsec_new "ipsec_new$ipsec_newruleid" ModifyRule "0"
        uci_set ipsec_new "ipsec_new$ipsec_newruleid" DeleteRule "1"
        uci_set ipsec_new "ipsec_new$ipsec_newruleid" IPVersion "$IP_version"
        uci_set ipsec_new "ipsec_new$ipsec_newruleid" Protocol $protocol
        uci_set ipsec_new "ipsec_new$ipsec_newruleid" LocalGwIp $localgwip
        uci_set ipsec_new "ipsec_new$ipsec_newruleid" RemoteGwIp $remotegwip
        uci_set ipsec_new "ipsec_new$ipsec_newruleid" LocalNw $localnw
        uci_set ipsec_new "ipsec_new$ipsec_newruleid" RemoteNw $remotenw
        uci_set ipsec_new "ipsec_new$ipsec_newruleid" LocalIp $localip
        uci_set ipsec_new "ipsec_new$ipsec_newruleid" RemoteIp $remoteip
        uci_set ipsec_new "ipsec_new$ipsec_newruleid" LocalNetmask $localnetmask
        uci_set ipsec_new "ipsec_new$ipsec_newruleid" RemoteNetmask $remotenetmask
        uci_set ipsec_new "ipsec_new$ipsec_newruleid" SpiIn $spiin
        uci_set ipsec_new "ipsec_new$ipsec_newruleid" SpiOut $spiout
        uci_set ipsec_new general count "$ipsec_newruleid"
      fi
     fi
     i=`expr $i + 1`
   done
 #   uci_set ipsec "test" Name "$FORM_pol_status_1"
}
! empty "$FORM_save_ipsec_policy" && {
  SAVED=1
  unvalid=0
  save_ipsec_policy_apply="n"
  if [ "$FORM_IP_version" == "ip" ] ; then
    netmask_version=netmask
  else
    netmask_version=netmask6
  fi
  count=`uci get ipsec.general.count`
  i=1
  while [ $i -le "$count" ]
  do
    polname=`uci get ipsec."ipsec$i".Name`
###### IPsec policy name duplication verification ################
    if [ "$i" != "$FORM_policyid" ] ; then
      equal $polname "$FORM_policy_name" && {
        append validate_error "ERROR in Policy Name: "$FORM_policy_name" policy name already exist"
        unvalid=1
      }
    fi

    i=`expr $i + 1`
  done
  case "$FORM_local_nw" in
    "single") V_LIP="required" ;;
    "subnet") V_LIP="required"
              V_LNM="required" ;;
    *) V_LIP=""
       V_LNM="" ;;
  esac
  case "$FORM_remote_nw" in
    single) V_RIP="required" ;;
    subnet) V_RIP="required"
            V_RNM="required" ;;
    *) V_RIP=""
       V_RNM="" ;;
  esac
  case "$FORM_spi_in" in
    0x*|0X*) V_SI="required min=5"
             D_SI="hexdec" ;;
    *) V_SI="required min=256"
       D_SI="int" ;;
  esac
  case "$FORM_spi_out" in
    0x*|0X*) V_SO="required min=5"
             D_SO="hexdec" ;;
    *) V_SO="required min=256"
       D_SO="int" ;;
  esac
  ###min and max length in hexdec type is 2*string_type_length + 2(0x length)
  case "$FORM_encrypt_alg" in
    des-cbc) case "$FORM_key_in" in
               0x*|0X*) V_EKI="required min=18 max=18"
                        D_EKI="hexdec" ;;
               *) V_EKI="required min=8 max=8"
                  D_EKI="string" ;;
             esac
             case "$FORM_key_out" in
               0x*|0X*) V_EKO="required min=18 max=18"
                        D_EKO="hexdec" ;;
               *) V_EKO="required min=8 max=8"
                  D_EKO="string" ;;
             esac
           ;;
    3des-cbc) case "$FORM_key_in" in
               0x*|0X*) V_EKI="required min=50 max=50"
                        D_EKI="hexdec" 
                        str1=$(echo $FORM_key_in | cut -c 3-18)
                        str2=$(echo $FORM_key_in | cut -c 19-34)
                        str3=$(echo $FORM_key_in | cut -c 35-50)
                        equal "$str1" "$str2" && {
                          append validate_error "Invalid encryption key-in: First 8 bytes should not equal second 8 bytes"
                          unvalid=1
                        }
                        equal "$str2" "$str3" && {
                          append validate_error "Invalid encryption key-in: Second 8 bytes should not equal third 8 bytes"
                          unvalid=1
                        } ;;
               *) V_EKI="required min=24 max=24"
                  D_EKI="string" 
                  str1=$(echo $FORM_key_in | cut -c 1-8)
                  str2=$(echo $FORM_key_in | cut -c 9-16)
                  str3=$(echo $FORM_key_in | cut -c 17-24)
                  equal "$str1" "$str2" && {
                    append validate_error "Invalid encryption key-in: First 8 bytes should not equal second 8 bytes"
                    unvalid=1
                  }
                  equal "$str2" "$str3" && {
                    append validate_error "Invalid encryption key-in: Second 8 bytes should not equal third 8 bytes"
                    unvalid=1
                  } ;;
              esac
              case "$FORM_key_out" in
               0x*|0X*) V_EKO="required min=50 max=50"
                        D_EKO="hexdec" 
                        str1=$(echo $FORM_key_out | cut -c 3-18)
                        str2=$(echo $FORM_key_out | cut -c 19-34)
                        str3=$(echo $FORM_key_out | cut -c 35-50)
                        equal "$str1" "$str2" && {
                          append validate_error "Invalid encryption key-out: First 8 bytes should not equal second 8 bytes"
                          unvalid=1
                        }
                        equal "$str2" "$str3" && {
                          append validate_error "Invalid encryption key-out: Second 8 bytes should not equal third 8 bytes"
                          unvalid=1
                        } ;;
               *) V_EKO="required min=24 max=24"
                  D_EKO="string" 
                  str1=$(echo $FORM_key_out | cut -c 1-8)
                  str2=$(echo $FORM_key_out | cut -c 9-16)
                  str3=$(echo $FORM_key_out | cut -c 17-24)
                  equal "$str1" "$str2" && {
                    append validate_error "Invalid encryption key-out: First 8 bytes should not equal second 8 bytes"
                    unvalid=1
                  }
                  equal "$str2" "$str3" && {
                    append validate_error "Invalid encryption key-out: Second 8 bytes should not equal third 8 bytes"
                    unvalid=1
                  } ;;
              esac
            ;;
    aes-128) case "$FORM_key_in" in
               0x*|0X*) V_EKI="required min=34 max=34"
                        D_EKI="hexdec" ;;
               *) V_EKI="required min=16 max=16"
                  D_EKI="string" ;;
              esac
              case "$FORM_key_out" in
               0x*|0X*) V_EKO="required min=34 max=34"
                        D_EKO="hexdec" ;;
               *) V_EKO="required min=16 max=16"
                  D_EKO="string" ;;
              esac
            ;;
     aes-192) case "$FORM_key_in" in
               0x*|0X*) V_EKI="required min=50 max=50"
                        D_EKI="hexdec" ;;
               *) V_EKI="required min=24 max=24"
                  D_EKI="string" ;;
              esac
              case "$FORM_key_out" in
               0x*|0X*) V_EKO="required min=50 max=50"
                        D_EKO="hexdec" ;;
               *) V_EKO="required min=24 max=24"
                  D_EKO="string" ;;
              esac
            ;;
     aes-256) case "$FORM_key_in" in
               0x*|0X*) V_EKI="required min=66 max=66"
                        D_EKI="hexdec" ;;
               *) V_EKI="required min=32 max=32"
                  D_EKI="string" ;;
              esac
              case "$FORM_key_out" in
               0x*|0X*) V_EKO="required min=66 max=66"
                        D_EKO="hexdec" ;;
               *) V_EKO="required min=32 max=32"
                  D_EKO="string" ;;
              esac
            ;;
    *) V_EKI=""
       V_EKO=""
       D_EKI="string"
       D_EKO="string" ;;
  esac
  case "$FORM_auth_alg" in
    hmac-md5) case "$FORM_auth_key_in" in
               0x*|0X*) V_AKI="required min=34 max=34"
                        D_AKI="hexdec" ;;
               *) V_AKI="required min=16 max=16"
                  D_AKI="string";;
              esac
              case "$FORM_auth_key_out" in
               0x*|0X*) V_AKO="required min=34 max=34"
                        D_AKO="hexdec" ;;
               *) V_AKO="required min=16 max=16"
                  D_AKO="string";;
              esac
             ;;
    hmac-sha1) case "$FORM_auth_key_in" in
               0x*|0X*) V_AKI="required min=42 max=42"
                        D_AKI="hexdec" ;;
               *) V_AKI="required min=20 max=20"
                  D_AKI="string";;
              esac
              case "$FORM_auth_key_out" in
               0x*|0X*) V_AKO="required min=42 max=42"
                        D_AKO="hexdec" ;;
               *) V_AKO="required min=20 max=20"
                  D_AKO="string";;
              esac
            ;;
    hmac-sha2-256) case "$FORM_auth_key_in" in
                     0x*|0X*) V_AKI="required min=66 max=66"
                              D_AKI="hexdec" ;;
                     *) V_AKI="required min=32 max=32"
                        D_AKI="string";;
                    esac
                    case "$FORM_auth_key_out" in
                     0x*|0X*) V_AKO="required min=66 max=66"
                              D_AKO="hexdec" ;;
                     *) V_AKO="required min=32 max=32"
                        D_AKO="string";;
                    esac
                  ;;
    *) V_AKI=""
       V_AKO=""
       D_AKI="string"
       D_AKO="string" ;;
  esac
validate <<EOF
hostname|FORM_policy_name|@TR<<Policy Name>>|required|$FORM_policy_name
$FORM_IP_version|FORM_local_gw_ipaddr|@TR<<Local Gateway IP address>>|required|$FORM_local_gw_ipaddr
$FORM_IP_version|FORM_remote_gw_ipaddr|@TR<<Remote Gateway IP address>>|required|$FORM_remote_gw_ipaddr
$FORM_IP_version|FORM_local_start_ip|@TR<<Local network IP address>>|$V_LIP|$FORM_local_start_ip
$netmask_version|FORM_local_subnet_mask|@TR<<Local network subnetmask>>|$V_LNM|$FORM_local_subnet_mask
$FORM_IP_version|FORM_remote_start_ip|@TR<<Remote network IP address>>|$V_RIP|$FORM_remote_start_ip
$netmask_version|FORM_remote_subnet_mask|@TR<<Remote network subnetmask>>|$V_RNM|$FORM_remote_subnet_mask
$D_SI|FORM_spi_in|@TR<<SPI in>>|$V_SI|$FORM_spi_in
$D_SO|FORM_spi_out|@TR<<SPI out>>|$V_SO|$FORM_spi_out
$D_EKI|FORM_key_in|@TR<<Encryption key in>>|$V_EKI|$FORM_key_in
$D_EKO|FORM_key_out|@TR<<Encryption key out>>|$V_EKO|$FORM_key_out
$D_AKI|FORM_auth_key_in|@TR<<Authentication key in>>|$V_AKI|$FORM_auth_key_in
$D_AKO|FORM_auth_key_out|@TR<<Authentication key out>>|$V_AKO|$FORM_auth_key_out
EOF
  equal "$?" 0 && ! equal "$unvalid" 1 && {
    ipsecruleid=`uci get ipsec.general.count`
  #  ipsecruleid=`expr $ipsecruleid + 1`
    polname="ipsec$FORM_policyid"
    status=`uci get ipsec.$polname.StatusEnable`
    if [ "$status" = "1" ] ; then
      oldIPversion=`uci get ipsec.$polname.IPVersion`
      oldprotocol=`uci get ipsec.$polname.Protocol`
      oldlocalgwip=`uci get ipsec.$polname.LocalGwIp`
      oldremotegwip=`uci get ipsec.$polname.RemoteGwIp`
      oldlocalnw=`uci get ipsec.$polname.LocalNw`
      oldremotenw=`uci get ipsec.$polname.RemoteNw`
      oldlocalip=`uci get ipsec.$polname.LocalIp`
      if [ "$oldlocalnw" = "subnet" ] ; then
        oldlocalnetmask=`uci get ipsec.$polname.LocalNetmask`
      else
        oldlocalnetmask=""
      fi
      oldremoteip=`uci get ipsec.$polname.RemoteIp`
      if [ "$oldremotenw" = "subnet" ] ; then
        oldremotenetmask=`uci get ipsec.$polname.RemoteNetmask`
      else
        oldremotenetmask=""
      fi
      oldspiin=`uci get ipsec.$polname.SpiIn`
      oldspiout=`uci get ipsec.$polname.SpiOut`   
    fi
    uci_add ipsec ipsec "$polname"
    uci_set ipsec "$polname" Name "$FORM_policy_name"
    uci_set ipsec "$polname" IPVersion "$FORM_IP_version"
    uci_set ipsec "$polname" Protocol "$FORM_protocol_type"
    uci_set ipsec "$polname" LocalGwIp "$FORM_local_gw_ipaddr"
    uci_set ipsec "$polname" RemoteGwIp "$FORM_remote_gw_ipaddr"
    uci_set ipsec "$polname" LocalNw "$FORM_local_nw"
    uci_set ipsec "$polname" RemoteNw "$FORM_remote_nw"
    uci_set ipsec "$polname" LocalIp "$FORM_local_start_ip"
    uci_set ipsec "$polname" LocalNetmask "$FORM_local_subnet_mask"
    uci_set ipsec "$polname" RemoteIp "$FORM_remote_start_ip"
    uci_set ipsec "$polname" RemoteNetmask "$FORM_remote_subnet_mask"
    uci_set ipsec "$polname" SpiIn "$FORM_spi_in"
    uci_set ipsec "$polname" SpiOut "$FORM_spi_out"
    if [ "$FORM_protocol_type" = "ah" ] ; then
      uci_set ipsec "$polname" EncAlgo " "
    else
      uci_set ipsec "$polname" EncAlgo "$FORM_encrypt_alg"
    fi
    uci_set ipsec "$polname" EncKeyIn "$FORM_key_in"
    uci_set ipsec "$polname" EncKeyOut "$FORM_key_out"
    uci_set ipsec "$polname" AuthAlgo "$FORM_auth_alg"
    uci_set ipsec "$polname" AuthKeyIn "$FORM_auth_key_in"
    uci_set ipsec "$polname" AuthKeyOut "$FORM_auth_key_out"

    if [ "$status" = "1" ] ; then
      ipsec_newruleid=`uci get ipsec_new.general.count`
      ipsec_newruleid=`expr $ipsec_newruleid + 1`
      uci_add ipsec_new ipsec  "ipsec_new$ipsec_newruleid"
#     uci_set ipsec_new "ipsec$ipsec_newruleid" Name "$FORM_policy_name"
      uci_set ipsec_new "ipsec_new$ipsec_newruleid" NewRule "0"
      uci_set ipsec_new "ipsec_new$ipsec_newruleid" ModifyRule "1"
      uci_set ipsec_new "ipsec_new$ipsec_newruleid" DeleteRule "0"
      uci_set ipsec_new "ipsec_new$ipsec_newruleid" IPVersion "$FORM_IP_version"
      uci_set ipsec_new "ipsec_new$ipsec_newruleid" OldIPVersion "$oldIPversion"
      uci_set ipsec_new "ipsec_new$ipsec_newruleid" Protocol "$FORM_protocol_type"
      uci_set ipsec_new "ipsec_new$ipsec_newruleid" OldProtocol "$oldprotocol"
      uci_set ipsec_new "ipsec_new$ipsec_newruleid" LocalGwIp "$FORM_local_gw_ipaddr"
      uci_set ipsec_new "ipsec_new$ipsec_newruleid" RemoteGwIp "$FORM_remote_gw_ipaddr"
      uci_set ipsec_new "ipsec_new$ipsec_newruleid" OldLocalGwIp "$oldlocalgwip"
      uci_set ipsec_new "ipsec_new$ipsec_newruleid" OldRemoteGwIp "$oldremotegwip"
      uci_set ipsec_new "ipsec_new$ipsec_newruleid" LocalNw "$FORM_local_nw"
      uci_set ipsec_new "ipsec_new$ipsec_newruleid" OldLocalNw "$oldlocalnw"
      uci_set ipsec_new "ipsec_new$ipsec_newruleid" RemoteNw "$FORM_remote_nw"
      uci_set ipsec_new "ipsec_new$ipsec_newruleid" OldRemoteNw "$oldremotenw"
      uci_set ipsec_new "ipsec_new$ipsec_newruleid" LocalIp "$FORM_local_start_ip"
      uci_set ipsec_new "ipsec_new$ipsec_newruleid" OldLocalIp "$oldlocalip"
      uci_set ipsec_new "ipsec_new$ipsec_newruleid" LocalNetmask "$FORM_local_subnet_mask"
      uci_set ipsec_new "ipsec_new$ipsec_newruleid" OldLocalNetmask "$oldlocalnetmask"
      uci_set ipsec_new "ipsec_new$ipsec_newruleid" RemoteIp "$FORM_remote_start_ip"
      uci_set ipsec_new "ipsec_new$ipsec_newruleid" OldRemoteIp "$oldremoteip"
      uci_set ipsec_new "ipsec_new$ipsec_newruleid" RemoteNetmask "$FORM_remote_subnet_mask"
      uci_set ipsec_new "ipsec_new$ipsec_newruleid" OldRemoteNetmask "$oldremotenetmask"
      uci_set ipsec_new "ipsec_new$ipsec_newruleid" SpiIn "$FORM_spi_in"
      uci_set ipsec_new "ipsec_new$ipsec_newruleid" OldSpiIn "$oldspiin"
      uci_set ipsec_new "ipsec_new$ipsec_newruleid" SpiOut "$FORM_spi_out"
      uci_set ipsec_new "ipsec_new$ipsec_newruleid" OldSpiOut "$oldspiout"
      if [ "$FORM_protocol_type" = "ah" ] ; then
        uci_set ipsec_new "ipsec_new$ipsec_newruleid" EncAlgo " "
      else
        uci_set ipsec_new "ipsec_new$ipsec_newruleid" EncAlgo "$FORM_encrypt_alg"
      fi
      uci_set ipsec_new "ipsec_new$ipsec_newruleid" EncKeyIn "$FORM_key_in"
      uci_set ipsec_new "ipsec_new$ipsec_newruleid" EncKeyOut "$FORM_key_out"
      uci_set ipsec_new "ipsec_new$ipsec_newruleid" AuthAlgo "$FORM_auth_alg"
      uci_set ipsec_new "ipsec_new$ipsec_newruleid" AuthKeyIn "$FORM_auth_key_in"
      uci_set ipsec_new "ipsec_new$ipsec_newruleid" AuthKeyOut "$FORM_auth_key_out"
      uci_set ipsec_new "ipsec_new$ipsec_newruleid" PolicyId "$FORM_policyid"
      uci_set ipsec_new general count "$ipsec_newruleid"
    fi
    save_ipsec_policy_apply="y"
    #config_set "ipsec$ipsecruleid" Name "$FORM_policy_name"
    #config_set "ipsec$ipsecruleid" Protocol "$FORM_protocol_type"
    #config_set "ipsec$ipsecruleid" RemoteGwIp "$FORM_remote_gw_ipaddr"
    #config_set "ipsec$ipsecruleid" LocalNw "$FORM_local_nw"
    #config_set "ipsec$ipsecruleid" RemoteNw "$FORM_remote_nw"
    #config_set "ipsec$ipsecruleid" LocalIp "$FORM_local_start_ip"
    #config_set "ipsec$ipsecruleid" LocalNetmask "$FORM_local_subnet_mask"
    #config_set "ipsec$ipsecruleid" RemoteIp "$FORM_remote_start_ip"
    #config_set "ipsec$ipsecruleid" RemoteNetmask "$FORM_remote_subnet_mask"
    #config_set "ipsec$ipsecruleid" SpiIn "$FORM_spi_in"
    #config_set "ipsec$ipsecruleid" SpiOut "$FORM_spi_out"
    #config_set "ipsec$ipsecruleid" EncAlgo "$FORM_encrypt_alg"
    #config_set "ipsec$ipsecruleid" EncKeyIn "$FORM_key_in"
    #config_set "ipsec$ipsecruleid" EncKeyOut "$FORM_key_out"
    #config_set "ipsec$ipsecruleid" AuthAlgo "$FORM_auth_alg"
    #config_set "ipsec$ipsecruleid" AuthKeyIn "$FORM_auth_key_in"
    #config_set "ipsec$ipsecruleid" AuthKeyOut "$FORM_auth_key_out"
  }
}

! empty "$FORM_delete_ipsec_policy" && {
  count=`uci get ipsec.general.count`
  polname="ipsec$FORM_delete_ipsec_policy"
  status=`uci get ipsec.$polname.StatusEnable`
  if [ "$status" = "1" ] ; then
    IPversion=`uci get ipsec.$polname.IPVersion`
    protocol=`uci get ipsec.$polname.Protocol`
    localgwip=`uci get ipsec.$polname.LocalGwIp`
    remotegwip=`uci get ipsec.$polname.RemoteGwIp`
    localnw=`uci get ipsec.$polname.LocalNw`
    remotenw=`uci get ipsec.$polname.RemoteNw`
    localip=`uci get ipsec.$polname.LocalIp`
    if [ "$localnw" = "subnet" ] ; then
      localnetmask=`uci get ipsec.$polname.LocalNetmask`
    else
      localnetmask=""
    fi
    remoteip=`uci get ipsec.$polname.RemoteIp`
    if [ "$remotenw" = "subnet" ] ; then
      remotenetmask=`uci get ipsec.$polname.RemoteNetmask`
    else
      remotenetmask=""
    fi
    spiin=`uci get ipsec.$polname.SpiIn`
    spiout=`uci get ipsec.$polname.SpiOut`
  
    ipsec_newruleid=`uci get ipsec_new.general.count`
    ipsec_newruleid=`expr $ipsec_newruleid + 1`
    uci_add ipsec_new ipsec  "ipsec_new$ipsec_newruleid"
    uci_set ipsec_new "ipsec_new$ipsec_newruleid" NewRule "0"
    uci_set ipsec_new "ipsec_new$ipsec_newruleid" ModifyRule "0"
    uci_set ipsec_new "ipsec_new$ipsec_newruleid" DeleteRule "1"
    uci_set ipsec_new "ipsec_new$ipsec_newruleid" IPVersion "$IPversion"
    uci_set ipsec_new "ipsec_new$ipsec_newruleid" Protocol $protocol
    uci_set ipsec_new "ipsec_new$ipsec_newruleid" LocalGwIp $localgwip
    uci_set ipsec_new "ipsec_new$ipsec_newruleid" RemoteGwIp $remotegwip
    uci_set ipsec_new "ipsec_new$ipsec_newruleid" LocalNw $localnw
    uci_set ipsec_new "ipsec_new$ipsec_newruleid" RemoteNw $remotenw
    uci_set ipsec_new "ipsec_new$ipsec_newruleid" LocalIp $localip
    uci_set ipsec_new "ipsec_new$ipsec_newruleid" RemoteIp $remoteip
    uci_set ipsec_new "ipsec_new$ipsec_newruleid" LocalNetmask $localnetmask
    uci_set ipsec_new "ipsec_new$ipsec_newruleid" RemoteNetmask $remotenetmask
    uci_set ipsec_new "ipsec_new$ipsec_newruleid" SpiIn $spiin
    uci_set ipsec_new "ipsec_new$ipsec_newruleid" SpiOut $spiout
    uci_set ipsec_new general count "$ipsec_newruleid"
  fi
  ipsecruleid=$FORM_delete_ipsec_policy
  
  uci_remove ipsec "ipsec$ipsecruleid"
  #ipsec_next_rule=`expr $ipsecruleid + 1`
  while [ $ipsecruleid -lt $count ]
  do
    uci_rename ipsec ipsec`expr $ipsecruleid + 1` ipsec$ipsecruleid
    ipsecruleid=`expr $ipsecruleid + 1`
    #ipsecbridgeid_next=`expr $bridgeid_next + 1`
  done
  uci_set ipsec general count `expr $count - 1`
  #config_set general count `expr $count - 1`

  #ipsec_newruleid=`uci get ipsec_new.general.count`
  #ipsec_newruleid=`expr $ipsec_newruleid + 1`
  #uci_add ipsec_new ipsec  "ipsec$ipsec_newruleid"
  #uci_set ipsec_new "ipsec$ipsec_newruleid" NewRule ""
  #uci_set ipsec_new "ipsec$ipsec_newruleid" DeleteRule "1"
  #uci_set ipsec_new "ipsec$ipsec_newruleid" Protocol $protocol
  #uci_set ipsec_new "ipsec$ipsec_newruleid" RemoteGwIp $remotegwip
  #uci_set ipsec_new "ipsec$ipsec_newruleid" LocalNw $localnw
  #uci_set ipsec_new "ipsec$ipsec_newruleid" RemoteNw $remotenw
  #uci_set ipsec_new "ipsec$ipsec_newruleid" LocalIp $localip
  #uci_set ipsec_new "ipsec$ipsec_newruleid" RemoteIp $remoteip
  #uci_set ipsec_new "ipsec$ipsec_newruleid" LocalNetmask $localnetmask
  #uci_set ipsec_new "ipsec$ipsec_newruleid" RemoteNetmask $remotenetmask
  #uci_set ipsec_new "ipsec$ipsec_newruleid" SpiIn $spiin
  #uci_set ipsec_new "ipsec$ipsec_newruleid" SpiOut $spiout
  #uci_set ipsec_new general count "$ipsec_newruleid"
#  uci_set ipsec_new "ipsec$ipsec_newruleid" ruleid "ipsec$FORM_delete_ipsec_policy"
}

#####################################################################
header "VPN" "Ipsec Policy" "@TR<<Ipsec Policy Configuration>>" 'onLoad=nwmodechange(this);' 
#####################################################################
cat <<EOF
<script type="text/javascript" src="/webif.js "></script>
<script type="text/javascript">
<!--
function nwmodechange()
{
 /* var v;
        
  alert(value('local_nw'));
  alert(document.forms[1].local_nw.value);*/
  if ( document.forms[1].local_nw.value == 'single' )
  {
    set_visible('local_start_ip', 1);
    set_visible('local_end_ip', 0);
    set_visible('local_subnet_mask', 0);
  }
  else if ( document.forms[1].local_nw.value == 'range' )
  {
    set_visible('local_start_ip', 1);
    set_visible('local_end_ip', 1);
    set_visible('local_subnet_mask', 0);
  }
  else if ( document.forms[1].local_nw.value == 'subnet' )
  {
    set_visible('local_start_ip', 1);
    set_visible('local_end_ip', 0);
    set_visible('local_subnet_mask', 1);
  }
  else
  {
    set_visible('local_start_ip', 0);
    set_visible('local_end_ip', 0);
    set_visible('local_subnet_mask', 0);
  }
  
  if ( document.forms[1].remote_nw.value == 'single' )
  {
    set_visible('remote_start_ip', 1);
    set_visible('remote_end_ip', 0);
    set_visible('remote_subnet_mask', 0);
  }
  else if ( document.forms[1].remote_nw.value == 'range' )
  {
    set_visible('remote_start_ip', 1);
    set_visible('remote_end_ip', 1);
    set_visible('remote_subnet_mask', 0);
  }
  else if ( document.forms[1].remote_nw.value == 'subnet' )
  {
    set_visible('remote_start_ip', 1);
    set_visible('remote_end_ip', 0);
    set_visible('remote_subnet_mask', 1);
  }
  else
  {
    set_visible('remote_start_ip', 0);
    set_visible('remote_end_ip', 0);
    set_visible('remote_subnet_mask', 0);
  }

  if ( document.forms[1].protocol_type.value == 'esp' )
  {
    set_visible('encrypt_alg', 1);
    if ( document.forms[1].encrypt_alg.value == 'null' )
    {
      set_visible('key_in', 0);
      set_visible('key_out', 0);
    }
    else
    {
      set_visible('key_in', 1);
      set_visible('key_out', 1);
    }
  }
  else
  {
    set_visible('encrypt_alg', 0);
    set_visible('key_in', 0);
    set_visible('key_out', 0);
  }
  if ( document.forms[1].auth_alg.value == 'null' )
  {
    set_visible('auth_key_in', 0);
    set_visible('auth_key_out', 0);
  }
  else
  {
    set_visible('auth_key_in', 1);
    set_visible('auth_key_out', 1);
  }
 /* v = isset('local_nw', '0');
  set_visible('wanip', v);
  v = isset('local', '0');
  set_visible('localip', v);
                                        
  hide('save');
  show('save');*/
}
-->
</script>
EOF

! empty "$validate_error" && {
echo "<h3 class=\"warning\">$validate_error</h3>"
}

count=`uci get ipsec.general.count`

echo "<div class=\"settings\">"
echo "<th colspan=\"11\"><h3><strong>" List of Existing Ipsec Policies: "</strong></h3></th>"
echo "<div class=\"settings-content-inner\">"
echo "<table style=\"width: 96%; text-align: left; font-size: 0.8em;\" border=\"0\" cellpadding=\"3\" cellspacing=\"3\" align=\"center\"><form name=\"apply_ipsec_policy\" action=\"/cgi-bin/webif/vpn-ipsec.sh\" enctype=\"multipart/form-data\" method=\"post\"> <tbody>"
echo "<tr class=\"odd\"><th>Policy Name</th><th>Local Network</th><th>Remote Network</th><th>Encryption</th><th>Authentication</th><th style=\"text-align: center;\">Status</th><th style=\"text-align: center;\">Actions</th></tr>"
if [ $count = 0 ]; then
  echo "<tr class=\"tr_bg\"><td colspan=\"7\">There are no ipsec policies</td></tr>"
fi
i=1
while [ $i -le "$count" ]
do
  PolName="ipsec$i"
  #config_get Name $PolName Name
  #config_get LocalNw $PolName LocalNw
  Name=`uci get ipsec.$PolName.Name`
  LocalNw=`uci get ipsec.$PolName.LocalNw`
  if [ "$LocalNw" = "any" ] ; then
    LocalNetwork="Any"
  elif [ "$LocalNw" = "single" ] ; then
    LocalNetwork=`uci get ipsec.$PolName.LocalIp`
    #config_get LocalNetwork $PolName LocalIp
  elif [ "$LocalNw" = "subnet" ] ; then
    LocalNetwork=`uci get ipsec.$PolName.LocalIp`-`uci get ipsec.$PolName.LocalNetmask`
    #config_get ipaddr $PolName LocalIp
    #config_get netmask $PolName LocalNetmask
    #LocalNetwork="$ipaddr-$netmask"
  else
    LocalNetwork="-"
  fi
  RemoteNw=`uci get ipsec.$PolName.RemoteNw`
  #config_get RemoteNw $PolName RemoteNw
  if [ "$RemoteNw" = "any" ] ; then
    RemoteNetwork="Any"
  elif [ "$RemoteNw" = "single" ] ; then
    RemoteNetwork=`uci get ipsec.$PolName.RemoteIp`
    #config_get RemoteNetwork $PolName RemoteIp
  elif [ "$RemoteNw" = "subnet" ] ; then
    RemoteNetwork=`uci get ipsec.$PolName.RemoteIp`-`uci get ipsec.$PolName.RemoteNetmask`
    #config_get ipaddr $PolName RemoteIp
    #config_get netmask $PolName RemoteNetmask
    #RemoteNetwork="$ipaddr-$netmask"
  else
    RemoteNetwork="-"
  fi
  #config_get AuthAlgo $PolName AuthAlgo
  #config_get EncAlgo $PolName EncAlgo
  AuthAlgo=`uci get ipsec.$PolName.AuthAlgo`
  EncAlgo=`uci get ipsec.$PolName.EncAlgo`

  echo "<td class=\"tr_bg\">$Name</td>"
  echo "<td class=\"tr_bg\">$LocalNetwork</td>"
  echo "<td class=\"tr_bg\">$RemoteNetwork</td>"
  echo "<td class=\"tr_bg\">$EncAlgo</td>"
  echo "<td class=\"tr_bg\">$AuthAlgo</td>"
  #PolStatus="yes"
  PolStatus=`uci get ipsec.$PolName.StatusEnable`
  if [ "$PolStatus" = "1" ] ; then
    status="yes"
  else
    status=""
  fi
 # echo "<td style=\"text-align: center;\"><a href=\"$SCRIPT_NAME?$status=$i\"><input id="pol_status_yes" type="checkbox" name="pol_status" value="$PolStatus" checked=""  /></a></td>"
  echo "<td class=\"tr_bg\" style=\"text-align: center;\"><input id="pol_status_yes_$i" type="checkbox" name="pol_status_$i" value="$status" checked=""  /></td>"
  echo "<td class=\"tr_bg\" style=\"text-align: center;\"><a href=\"$SCRIPT_NAME?display_ipsec_policy=$i\"><img alt=\"@TR<<edit>>\" src=\"/images/edit.gif\" title=\"@TR<<edit>>\" /></a>  <a href=\"$SCRIPT_NAME?delete_ipsec_policy=$i\"><img alt=\"@TR<<delete>>\" src=\"/images/x.gif\" title=\"@TR<<delete>>\" /></a></td></tr>"

  i=`expr $i + 1`
done
echo "<tr id=\"spacer1\" > <td colspan=\"2\"> <br> <input class=\"button-inner\" name=\"apply_ipsec_policy\" value=\"Save\" type=\"submit\"></td></tr>"



echo "</tbody></form></table></div><div class=\"clearfix\">&nbsp;</div></div>"

echo "<a class=\"addnew_ico\"href=\"$SCRIPT_NAME?new_ipsec_policy=1\"><span class=\"add\">@TR<<Add New ipsec policy>></span></a><br><br>"

add_ipsec_policy_failed="n"
[ -n "$FORM_add_ipsec_policy" -a "$add_ipsec_policy_apply" = "n" ] && add_ipsec_policy_failed="y"
[ -n "$FORM_new_ipsec_policy" -o "$add_ipsec_policy_failed" = "y" ] && {
#! empty "$FORM_new_ipsec_policy" && {
display_form <<EOF
onchange|nwmodechange
start_form|@TR<<New Ipsec policy Configuration>>
formtag_begin|add_ipsec_policy|$SCRIPT_NAME
helpitem|Encryption algorithm lengths
helptext|DES 8bytes, 3DES 24bytes, AES-128 16bytes, AES-192 24bytes, AES-256 32bytes.
helpitem|Authentication algorithm lengths
helptext|HMAC-MD5 16bytes, HMAC-SHA1 20bytes, HMAC-SHA2-256 32bytes.
field|@TR<<Policy Name>>|policy_name
text|policy_name|$FORM_policy_name
field|@TR<<IP Address version>>|IP_version
select|IP_version|$FORM_IP_version
option|ip|@TR<<IPV4>>
option|ip6|@TR<<IPV6>>
field|@TR<<Protocol Type>>|protocol_type
select|protocol_type|$FORM_protocol_type
option|esp|@TR<<ESP>>
option|ah|@TR<<AH>>
#field|@TR<<Mode>>|mode_type
#select|mode_type|$FORM_mode_type
#option|tunnel|@TR<<Tunnel>>
#option|transport|@TR<<Transport>>
field|@TR<<WAN IP Address>>|local_gw_ipaddr
text|local_gw_ipaddr|$FORM_local_gw_ipaddr
field|@TR<<Remote IP Address>>|remote_gw_ipaddr
text|remote_gw_ipaddr|$FORM_remote_gw_ipaddr
field|@TR<<Local Network>>|local_nw
select|local_nw|$FORM_local_nw
option|single|@TR<<Single>>
option|subnet|@TR<<Subnet>>
#option|range|@TR<<Range>>
#option|any|@TR<<Any>>
field|@TR<<IP Address>>|local_start_ip|hidden
text|local_start_ip|$FORM_local_start_ip
field|@TR<<End IP>>|local_end_ip|hidden
text|local_end_ip|$FORM_local_end_ip
field|@TR<<Subnet mask>>|local_subnet_mask|hidden
text|local_subnet_mask|$FORM_local_subnet_mask
field|@TR<<Remote Network>>|remote_nw
select|remote_nw|$FORM_remote_nw
option|single|@TR<<Single>>
option|subnet|@TR<<Subnet>>
#option|range|@TR<<Range>>
#option|any|@TR<<Any>>
field|@TR<<IP Address>>|remote_start_ip|hidden
text|remote_start_ip|$FORM_remote_start_ip
field|@TR<<End IP>>|remote_end_ip|hidden
text|remote_end_ip|$FORM_remote_end_ip
field|@TR<<Subnet mask>>|remote_subnet_mask|hidden
text|remote_subnet_mask|$FORM_remote_subnet_mask
field|@TR<<SPI in>>|spi_in
text|spi_in|$FORM_spi_in
field|@TR<<SPI out>>|spi_out
text|spi_out|$FORM_spi_out
field|@TR<<Encryption Algorithm>>|encrypt_alg
select|encrypt_alg|$FORM_encrypt_alg
option|null|@TR<<Null>>
option|des-cbc|@TR<<DES-CBC>>
option|3des-cbc|@TR<<3DES-CBC>>
option|aes-128|@TR<<AES-128>>
option|aes-192|@TR<<AES-192>>
option|aes-256|@TR<<AES-256>>
field|@TR<<Key in>>|key_in
text|key_in|$FORM_key_in
field|@TR<<Key out>>|key_out
text|key_out|$FORM_key_out
field|@TR<<Authentication Algorithm>>|auth_alg
select|auth_alg|$FORM_auth_alg
option|null|@TR<<Null>>
option|hmac-md5|@TR<<HMAC-MD5>>
option|hmac-sha1|@TR<<HMAC-SHA1>>
option|hmac-sha2-256|@TR<<HMAC-SHA2-256>>
field|@TR<<Key in>>|auth_key_in
text|auth_key_in|$FORM_auth_key_in
field|@TR<<Key out>>|auth_key_out
text|auth_key_out|$FORM_auth_key_out
field||spacer1
string|<br />
submit|add_ipsec_policy|@TR<<Add>>
submit||@TR<<Cancel>>
formtag_end
end_form
EOF
}

save_ipsec_policy_failed="n"
[ -n "$FORM_save_ipsec_policy" -a "$save_ipsec_policy_apply" = "n" ] && save_ipsec_policy_failed="y"
[ -n "$FORM_display_ipsec_policy" -o "$save_ipsec_policy_failed" = "y" ] && {
[ "$save_ipsec_policy_failed" = "y" ] && {
  FORM_display_ipsec_policy=$FORM_policyid
}
#! empty "$FORM_display_ipsec_policy" && {
display_form <<EOF
onchange|nwmodechange
start_form|@TR<<Edit Ipsec policy Configuration>>
formtag_begin|save_ipsec_policy|$SCRIPT_NAME
helpitem|Encryption algorithm lengths
helptext|DES 8bytes, 3DES 24bytes, AES-128 16bytes, AES-192 24bytes, AES-256 32bytes.
helpitem|Authentication algorithm lengths
helptext|HMAC-MD5 16bytes, HMAC-SHA1 20bytes, HMAC-SHA2-256 32bytes.
field|@TR<<Policy Name>>|policy_name
text|policy_name|$FORM_policy_name
field|@TR<<Policy ID>>
text|policyid|$FORM_display_ipsec_policy|||readonly
field|@TR<<IP Address version>>|IP_version
select|IP_version|$FORM_IP_version
option|ip|@TR<<IPV4>>
option|ip6|@TR<<IPV6>>
field|@TR<<Protocol Type>>|protocol_type
select|protocol_type|$FORM_protocol_type
option|esp|@TR<<ESP>>
option|ah|@TR<<AH>>
#field|@TR<<Mode>>|mode_type
#select|mode_type|$FORM_mode_type
#option|tunnel|@TR<<Tunnel>>
#option|transport|@TR<<Transport>>
field|@TR<<WAN IP Address>>|local_gw_ipaddr
text|local_gw_ipaddr|$FORM_local_gw_ipaddr
field|@TR<<Remote IP Address>>|remote_gw_ipaddr
text|remote_gw_ipaddr|$FORM_remote_gw_ipaddr
field|@TR<<Local Network>>|local_nw
select|local_nw|$FORM_local_nw
option|single|@TR<<Single>>
option|subnet|@TR<<Subnet>>
#option|range|@TR<<Range>>
#option|any|@TR<<Any>>
field|@TR<<IP Address>>|local_start_ip|hidden
text|local_start_ip|$FORM_local_start_ip
field|@TR<<End IP>>|local_end_ip|hidden
text|local_end_ip|$FORM_local_end_ip
field|@TR<<Subnet mask>>|local_subnet_mask|hidden
text|local_subnet_mask|$FORM_local_subnet_mask
field|@TR<<Remote Network>>|remote_nw
select|remote_nw|$FORM_remote_nw
option|single|@TR<<Single>>
option|subnet|@TR<<Subnet>>
#option|range|@TR<<Range>>
#option|any|@TR<<Any>>
field|@TR<<IP Address>>|remote_start_ip|hidden
text|remote_start_ip|$FORM_remote_start_ip
field|@TR<<End IP>>|remote_end_ip|hidden
text|remote_end_ip|$FORM_remote_end_ip
field|@TR<<Subnet mask>>|remote_subnet_mask|hidden
text|remote_subnet_mask|$FORM_remote_subnet_mask
field|@TR<<SPI in>>|spi_in
text|spi_in|$FORM_spi_in
field|@TR<<SPI out>>|spi_out
text|spi_out|$FORM_spi_out
field|@TR<<Encryption Algorithm>>|encrypt_alg
select|encrypt_alg|$FORM_encrypt_alg
option|null|@TR<<Null>>
option|des-cbc|@TR<<DES-CBC>>
option|3des-cbc|@TR<<3DES-CBC>>
option|aes-128|@TR<<AES-128>>
option|aes-192|@TR<<AES-192>>
option|aes-256|@TR<<AES-256>>
field|@TR<<Key in>>|key_in
text|key_in|$FORM_key_in
field|@TR<<Key out>>|key_out
text|key_out|$FORM_key_out
field|@TR<<Authentication Algorithm>>|auth_alg
select|auth_alg|$FORM_auth_alg
option|null|@TR<<Null>>
option|hmac-md5|@TR<<HMAC-MD5>>
option|hmac-sha1|@TR<<HMAC-SHA1>>
option|hmac-sha2-256|@TR<<HMAC-SHA2-256>>
field|@TR<<Key in>>|auth_key_in
text|auth_key_in|$FORM_auth_key_in
field|@TR<<Key out>>|auth_key_out
text|auth_key_out|$FORM_auth_key_out
field||spacer1
string|<br />
submit|save_ipsec_policy|@TR<<Save>>
submit||@TR<<Cancel>>
formtag_end
end_form
EOF
}

footer ?>
<!--
##WEBIF:name:VPN:520:Ipsec Policy
-->
