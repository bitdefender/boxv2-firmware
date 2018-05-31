#!/bin/sh

# Example Script  to configure in STA mode
# Here interface name is assumed as eth4 .please place correct interface name
# if changed in boot time.

# Default Access point to connect is "brcm" , please 
# change according to requirement. 

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
wl -i eth4 ap 0
wl -i eth4  eap 0
wl -i eth4 auth 0
wl -i eth4 closed 0       
wl -i eth4 country US
wl -i eth4  band a
wl -i eth4 chanspec 60/80
wl -i eth4 plcphdr long
wl -i eth4 rate 0
wl -i eth4 bg_rate 0
#wl -i eth4 mrate -1
wl -i eth4 bg_mrate -1
wl -i eth4 rateset default
wl -i eth4 mrate -1
wl -i eth4 bg_mrate -1
wl -i eth4 ap_isolate 0
wl -i eth4 wds none
wl -i eth4 wds
wl -i eth4 nrate -1
wl -i eth4 nmode 1
wl -i eth4 bw_cap 5g 0x7
wl -i eth4 obss_coex 1
sleep 2
wl -i eth4 up
sleep 2
wl -i eth4 join brcm
