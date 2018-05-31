#!/bin/ash

# Example Script  to configure in AP mode 
# Here interface name is assumed as eth4 .please place correct interface name
# if changed in boot time.


# Default  SSID is brcm and 
# IP/SUBNET  is 192.168.5.1/24, please change according to 
# Requirement .

wl -i eth4 down
wl -i eth4 rmwep  0
wl -i eth4 rmwep  1
wl -i eth4 rmwep  2
wl -i eth4 rmwep  3
wl -i eth4 rmwep  0
wl -i eth4 rmwep  1
wl -i eth4 rmwep  2
wl -i eth4 rmwep  3
wl -i eth4 rmwep  0
wl -i eth4 rmwep  1
wl -i eth4 rmwep  2
wl -i eth4 rmwep  3
wl -i eth4 rmwep  0
wl -i eth4 rmwep  1
wl -i eth4 rmwep  2
wl -i eth4 rmwep  3
wl -i eth4  wsec  0
wl -i eth4 wsec_restrict 0
wl -i eth4 wpa_auth  0
wl -i eth4  eap 0
wl -i eth4 auth 0
wl -i eth4 closed 0       
wl -i eth4 country US
wl -i eth4  band a
wl -i eth4 regulatory 0
wl -i eth4 radar 0  
wl -i eth4 spect 0  
wl -i eth4 chanspec 60/80
wl -i eth4 maxassoc 128
wl -i eth4 bss_maxassoc 128
wl -i eth4 wme 1 
wl -i eth4 ampdu 1
wl -i eth4 amsdu 1
wl -i eth4 plcphdr auto
wl -i eth4 rate 0
wl -i eth4 bg_rate 0
wl -i eth4 leddc 0x640000  
wl -i eth4 mrate -1
wl -i eth4 bg_mrate -1
wl -i eth4 rateset default
wl -i eth4 rtsthresh 2347
wl -i eth4 fragthresh 2346
wl -i eth4 dtim 1
wl -i eth4  bi 100
wl -i eth4 mrate -1
wl -i eth4 bg_mrate -1
wl -i eth4 rateset default
wl -i eth4 rtsthresh 2347
wl -i eth4 fragthresh 2346
wl -i eth4 dtim 1
wl -i eth4  bi 100
wl -i eth4 frameburst 0
wl -i eth4 ap_isolate 0
wl -i eth4 wds none
wl -i eth4 pwr_percent 100
wl -i eth4 mac none
wl -i eth4 macmode 0
wl -i eth4 lazywds 0
wl -i eth4 wds
wl -i eth4 nrate -1
wl -i eth4 nmode 1
wl -i eth4 bw_cap 5g 0x7
#wl -i eth4 ampdu 1
wl -i eth4 csscantimer 0
wl -i eth4 vhtmode 1
wl -i eth4 obss_coex 1

wl -i eth4 ssid brcm 
wl -i eth4 up

#wl -i eth4 msglevel err info assoc
ifconfig eth4 192.168.5.1/24
sleep 1
