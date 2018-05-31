#!/bin/sh
append DRIVERS "atheros_lsdk_wlan"

scan_atheros_lsdk_wlan() 
{
  local vap_id="$1"
  local device="$2"
  local wds
  local adhoc sta ap
	
  config_get ifname "$vap_id" interface
  config_set "$vap_id" ifname "${ifname:-ath}"
		
  mode=ap
  case "$mode" in
    adhoc|ahdemo|sta|ap)
      append $mode "$vap_id"
      ;;
    wds)
      config_get addr "$vap_id" bssid
      config_get ssid "$vap_id" ssid
      [ -z "$addr" -a -n "$ssid" ] && {
        config_set "$vap_id" wds 1
        config_set "$vap_id" mode sta
        mode="sta"
        addr="$ssid"
      }
      ${addr:+append $mode "$vap_id"}
      ;;
    *) echo "$device($vap_id): Invalid mode, ignored."; continue;;
  esac

  case "${adhoc:+1}:${sta:+1}:${ap+1}" in
  # valid mode combinations
    1::) wds="";;
    1::1);;
    :1:1)config_set "$device" nosbeacon 1;; # AP+STA, can't use beacon timers for STA
    :1:);;
    ::1);;
    ::);;
    *) echo "$device: Invalid mode combination in config"; return 1;;
  esac

# config_set "$device" VAPS "${ap:+$ap }${adhoc:+$adhoc }${ahdemo:+$ahdemo }${sta:+$sta }${wds:+$wds }"
}


disable_atheros_lsdk_wlan() (
  local vap_id="$1"
  local device="$2"

  # kill all running hostapd and wpa_supplicant processes that
  # are running on atheros_lsdk_wlan interfaces 
  config_get ifname "$vap_id" interface
  if [ -n "$ifname" ]; then
    for pid in `pidof hostapd wpa_supplicant`; do
      grep "$ifname" /proc/$pid/cmdline >/dev/null && kill $pid
    done
  fi
	
  include /lib/network
  if [ -n "$ifname" ]; then
    ifconfig "$ifname" down 2>/dev/null
    unbridge "$ifname"
    wlanconfig "$ifname" destroy 2>/dev/null
  fi

  return 0
)

enable_atheros_lsdk_wlan() {
  local vap_id="$1"
  local device="$2"

  config_get channel "$device" channel
  disable_atheros_lsdk_wlan "$vap_id" "$device"

  config_get devname "$device" devname
  [ -z "$devname" ] && { 
    echo "Invalid $device atheros_lsdk_wlan devname."
    return 
  }
  ifconfig $devname txqueuelen 1000
  config_get disable "$vap_id" disabled
  if [ "$disable" = "0" ]; then
    nosbeacon=
    config_get ifname "$vap_id" ifname
#   config_get rate "$device" rate ## which rate this one ?
    config_get frag "$device" cts_threshold
    config_get rts "$device" rts_threshold
#   config_get mode "$vif" mode
    mode=ap	
    config_get agnmode "$device" mode
#    if [ "$agnmode" != "11ac" ]; then
#      iwpriv $devname AMPDU 1  2>&- >&-
#      iwpriv $devname AMPDUFrames 32  2>&- >&-
#      iwpriv $devname AMPDULim 50000  2>&- >&-
#      iwpriv $devname txchainmask 7  2>&- >&-
#      iwpriv $devname rxchainmask 7  2>&- >&-
#    fi
    ifconfig $devname txqueuelen 1000  2>&- >&-

    config_get ifname "$vap_id" ifname
    ifname=$(wlanconfig "$ifname" create wlandev "$devname" wlanmode "$mode" ${nosbeacon:+nosbeacon})
    [ $? -ne 0 ] && {
      echo "enable_atheros($device): Failed to set up $mode vif $ifname" >&2
      return
    }
    config_set "$vap_id" ifname "$ifname"
    uci set "$vap_id"."$vap_id".interface="$ifname"
    uci commit $vap_id
    deviceid=`cat /sys/class/net/$devname/device/device`

   # iwconfig "$ifname" channel 0
   # iwpriv "$ifname" pureg 0
    pureg=0
    shortgi=0

    case "$agnmode" in
      *a)   agnmode=11A ;;
      *b)   agnmode=11B ;;
      11bg) agnmode=11G ;;
      11g)  agnmode=11G 
            pureg=1 ;; 
      11ac) agnmode=11ACVHT80 
    	    shortgi=1 ;;
      *n) 
	    case "$agnmode" in
            11an) 
              config_get channel_width ${device} channel_width
              case "$channel_width" in 
                20) 
                  shortgi=1 
                  agnmode=11NAHT20 
                  ;; 
                40-) 
                  shortgi=1 
                  agnmode=11NAHT40MINUS 
                  ;; 
                *|40+) 
                  shortgi=1 
                  agnmode=11NAHT40PLUS 
                  ;; 
              esac 
              ;; 
            11gn|11bgn) 
              config_get channel_width ${device} channel_width 
              case "$channel_width" in 
                20) 
                  shortgi=1 
                  agnmode=11NGHT20 
                  ;; 
                40-) 
                  shortgi=1 
                  agnmode=11NGHT40MINUS
                  ;; 
                *|40+) 
                  shortgi=1 
                  agnmode=11NGHT40PLUS 
                  ;; 
              esac 
              ;; 
          esac 
        ;; 
      *) agnmode=auto ;; 
    esac 

    case "$agnmode" in 
      11N*) 
        frag="off" 
        rts="off" 
        # Enabling shorr gaurd interval 
        iwpriv "$ifname" shortgi "$shortgi" 
        # iwpriv "$ifname" cwmmode "$cwmmode" 
        ;; 
    esac

    config_get ssid "$vap_id" ssid
    # Setting mode				
    iwpriv "$ifname" mode "$agnmode" 
    #Setting channel frequency
    iwconfig "$ifname" channel "$channel"
    iwconfig "$ifname" essid "$ssid"

    ifconfig "$ifname" txqueuelen 1000
    ifconfig "$ifname" up

    case "$agnmode" in
      11AC*)
	iwpriv "$ifname" wds 1
    esac
	
# iwconfig "$ifname" rate "$rate" >/dev/null 2>/dev/null 
#    if [ "$agnmode" != "11ACVHT80" ]; then
#      iwconfig "$ifname" rts "$rts" >/dev/null 2>/dev/null 
#      iwconfig "$ifname" frag "$frag" >/dev/null 2>/dev/null 
#    fi
    config_get multicast_rate $device multicast_rate
    let "mcast_rate=$multicast_rate*1000"
#    iwpriv "$ifname" mcast_rate 36000
    iwpriv "$ifname" mcast_rate $mcast_rate

    config_get_bool hidden "$vap_id" hidden_ssid 0
    iwpriv "$ifname" hide_ssid "$hidden"


    wpa=
#   case "$enc" in
#     WEP|wep)
#       iwpriv "$ifname" authmode 2
    config_get auth "$vap_id" authentication
    config_get enc "$vap_id" encryption
    case "$auth" in
      open|shared)
        case "$enc" in
          WEP*|wep*)
            case "$auth" in
              open)   $DEBUG iwpriv "$ifname" authmode 1 ;;
              shared) $DEBUG iwpriv "$ifname" authmode 2 ;;
            esac
            idxes="1 2 3 4"
            for idx in $idxes; do
              config_get key "$vap_id" "key${idx}" # config_get key "$vap_id" "key" key contains the selected key
              iwconfig "$ifname" key "[$idx]" "${key:-off}"
            done
            config_get key "$vap_id" key
            key="${key:-1}"
            case "$key" in
              *) iwconfig "$ifname" key "[$key]" ;;
            esac
            ;;
        esac
        ;;
      *) config_get key "$vap_id" key ;;
    esac

    case "$mode" in
      wds)
        config_get addr "$vap_id" bssid ### This configuration does not exist in vap. Mode ap supporting
        iwpriv "$ifname" wds_add "$addr"
        ;;
      adhoc|ahdemo)
        config_get addr "$vap_id" bssid ### This configuration does not exist in vap. Mode ap supporting
        [ -z "$addr" ] || { 
          iwconfig "$ifname" ap "$addr"
        }
        ;;
    esac
		
    local net_cfg bridge
    net_cfg=$(find_vap_bridge_interface $vap_id)   
    if [ -z "$net_cfg" ]; then
      config_get ipaddr $vap_id ipaddr
      if [ -n "$ipaddr" ]; then
        ifconfig ${ifname} $ipaddr
      fi
	
      config_get netmask $vap_id netmask
      if [ -n "$netmask" ]; then
        ifconfig ${ifname} netmask $netmask up
      fi
    else
      ifconfig ${ifname} 0.0.0.0 up
    fi

    net_cfg="$(find_net_config "$ifname")"
    [ -z "$net_cfg" ] || {
      bridge="$(bridge_interface "$net_cfg")"
      config_set "$vap_id" bridge "$bridge"
      start_net "$ifname" "$net_cfg"
    }
    #setting the mode
#    iwpriv "$ifname" mode "$agnmode"

#    iwpriv $ifname disablecoext 1

#    iwconfig "$ifname" essid "$ssid"
    case "$mode" in
      ap)
        config_get_bool isolate "$vap_id" isolate 0
        iwpriv "$ifname" ap_bridge "$((isolate^1))"
        if eval "type hostapd_setup_vif" 2>/dev/null >/dev/null; then
          hostapd_setup_vif "$vap_id" madwifi || {
            echo "enable_atheros($device, $vap_id): Failed to set up wpa for interface $ifname" >&2
            # make sure this wifi interface won't accidentally stay open without encryption
            ifconfig "$ifname" down
            wlanconfig "$ifname" destroy
            return
          }
        fi
        ;;
    esac
  fi
}


detect_atheros_lsdk_wlan() {
  local radio_mode
  cd /sys/class/net
  drv_index=$1
  radio_index=$2

  drv_info="$(head -`expr $radio_index + 1` /proc/bus/pci/devices | tail -c 8)"
  if [ "$drv_info" != "ath_pci" ]; then
    return 
  fi
  config_get found general radio${radio_index}_found
  if [ "$found" = "0" ]; then
    if [ -d wifi${drv_index} ]; then
      uci set wireless.radio${radio_index}.type="atheros_lsdk_wlan"
      uci set wireless.radio${radio_index}.devname="wifi$drv_index"
      uci set wireless.general.radio${radio_index}_found="1"
      echo "atheros  card found"
      uci commit wireless
      config_set "radio${radio_index}" type "atheros_lsdk_wlan"
      config_set "radio${radio_index}" devname "wifi$drv_index"
      config_set general "radio${radio_index}_found" "1"
    fi
  fi
  if [ -d wifi${drv_index} ]; then
    config_get devname "radio${radio_index}" devname
    deviceid=`cat /sys/class/net/$devname/device/device`
    if [ -n "$deviceid" ]; then
     if [ "$deviceid" != "0x003c" -a "$deviceid" != "0xabcd" ]; then
      config_get radio_mode "radio${radio_index}" mode
      if [ "$radio_mode" = "11ac" ]; then
        uci set wireless.radio${radio_index}.mode="11n"
        uci commit wireless
        config_set "radio${radio_index}" mode "11n"
	echo "The card does not support 11ac, but the radio$radio_index has 11ac wireless configuration. So, radio$radio_index mode is changing to 11n mode"
      fi
     fi
    fi
  fi
}
