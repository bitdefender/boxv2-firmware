hostapd_setup_vif() {
  local vif="$1"
  local driver="$2"
  local hostapd_cfg=


  # PSK/WPA and TKIP is not allowed in HT mode 
  if [ "$enc" = TKIP ] || [ "$enc" = tkip ]; then
    if [ "$agnmode" = 11NAHT20 ] || [ "$agnmode" = 11NGHT20 ] || [ "$agnmode" = 11NAHT40PLUS ] || [ "$agnmode" = 11NGHT40PLUS ] || [ "$agnmode" = 11NAHT40MINUS ] || [ "$agnmode" = 11NGHT40MINUS ]; then 
      echo " TKIP Encryption is not supported in HT Mode "
      return 0;
    fi
  fi 	

  # Examples:
  # psk-mixed/tkip 	=> WPA1+2 PSK, TKIP
  # wpa-psk2/tkip+aes	=> WPA2 PSK, CCMP+TKIP
  # wpa2/tkip+aes 	=> WPA2 RADIUS, CCMP+TKIP
  # ...

  # TODO: move this parsing function somewhere generic, so that
  # later it can be reused by drivers that don't use hostapd
	
  # crypto defaults: WPA2 vs WPA1
  case "$auth" in
    wpa2|WPA2|wpa2psk|WPA2PSK)
      wpa=2
      key_mgmt=WPA-PSK
      ;;
    *mixed*)
      wpa=3
      ;;
    *) 
      wpa=1
      key_mgmt=WPA-PSK
      ;;
  esac

  # explicit override for crypto setting
  case "$enc" in
    *tkip+aes|*TKIP+AES|*tkip+ccmp|*TKIP+CCMP) crypto="CCMP TKIP";;
    *tkip|*TKIP) crypto="TKIP";;
    *aes|*AES|*ccmp|*CCMP) crypto="CCMP";;
  esac
	
  # use crypto/auth settings for building the hostapd config
  case "$auth" in
# case "$enc" in
    *psk*|*PSK*)
      config_get psk "$vif" key
      append hostapd_cfg "wpa_passphrase=$psk" "$N"
      ;;
#   *wpa*|*WPA*)
    wpa|WPA|wpa2|WPA2)
    # FIXME: add wpa+radius here
      ;;
    *)
      return 0;
      ;;
  esac
  config_get ifname "$vif" ifname
  config_get bridge "$vif" bridge
  config_get ssid "$vif" ssid
  config_get radio_type "$vif" radio_type
  config_get devname "$radio_type" devname

  #Create topology file
	
  mkdir -p /tmp/hostapd

  # create Bss configuration file 	
  cp /etc/wpa2/security.conf /tmp/hostapd/bss-sec-$ifname.conf
  if [ -z $bridge ]; then
	echo "interface=$ifname" >> /tmp/hostapd/bss-sec-$ifname.conf
  else
	echo "interface=$ifname" >> /tmp/hostapd/bss-sec-$ifname.conf
	echo "bridge=$bridge" >> /tmp/hostapd/bss-sec-$ifname.conf
  fi

  echo "ssid=$ssid" >> /tmp/hostapd/bss-sec-$ifname.conf
  echo "wpa=$wpa" >> /tmp/hostapd/bss-sec-$ifname.conf
  echo "wpa_key_mgmt=$key_mgmt" >> /tmp/hostapd/bss-sec-$ifname.conf
  echo "wpa_pairwise=$crypto" >> /tmp/hostapd/bss-sec-$ifname.conf
  echo "$hostapd_cfg" >> /tmp/hostapd/bss-sec-$ifname.conf

  #	cat > /var/run/hostapd-$ifname.conf <<EOF
  #driver=$driver
  #interface=$ifname
  #${bridge:+bridge=$bridge}
  #ssid=$ssid
  #debug=0
  #wpa=$wpa
  #wpa_pairwise=$crypto
  #$hostapd_cfg
  #EOF
  #	hostapd -B /var/run/hostapd-$ifname.conf
  hostapd /tmp/hostapd/bss-sec-$ifname.conf -B
}

