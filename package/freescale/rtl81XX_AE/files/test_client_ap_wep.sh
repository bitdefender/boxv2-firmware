#!/bin/sh
#wlan0 will beacome the AP and  Client
#This test is for Open mode wep security 
#64-hex , default key is 098765421

CONFIG_ROOT_DIR="/var/rtl8192c"
SCRIPT_DIR=`cat $CONFIG_ROOT_DIR/wifi_script_dir`
START_WLAN=$SCRIPT_DIR/wlan_8192c.sh
IFCONFIG=ifconfig

show_usage(){
	echo "Example Usage: $0 [op_mode] <ssid>
	 		        op_mode: ap/sta 
	 		        ssid: destination ssid"  
	exit 1
}


if [ $# -lt 1 ]; then
echo "ERROR : incomplete command."
show_usage
fi

ROOT_IF=wlan0

if [ $1 = 'sta' ]; then 
	
	if [ -z "$2" ];then 
		show_usage
	fi

	echo "Set up configuring for STA(client) mode Please wait......"

	#DSSID = the SSID for the station/STA  mode will connect to
	#Please change accroding to this. 

	DSSID=$2

	#All Configuration paremeters are availble in /var/rtl8192c/wlan0
	
	#This is for 40MHz channel width
	echo 1 > $CONFIG_ROOT_DIR/$ROOT_IF/channel_bonding
	
	$IFCONFIG $ROOT_IF down


	#This will start the client configuratioon start 
	#This will connect to BGN mode value of band is 11 set in the client_init.sh script
	#1:B, 2:G, 4:A, 8:N, 64:AC
	#band=11 : BGN
	
	#Start the Encryption here 
	#64-hex , default key is 098765421
	$SCRIPT_DIR/wep-64-hex.sh $ROOT_IF $1

	$SCRIPT_DIR/client_init.sh $ROOT_IF "$DSSID" 00:E0:4C:81:86:80
	
	#Set the IP to the interface here , or set the dhcp settings
	$IFCONFIG $ROOT_IF 192.168.3.20/24 
	
	echo "Client Mode Configuration Setting Completed Enjoy"
	
elif [ $1 = 'ap' ];then

	echo "Set up is Configuring for AP mode Please wait......"
	
	
 	# Change the Some default Parmeter here 
 	     # 1 .Enable 40MHz channel width
	echo 1 > $CONFIG_ROOT_DIR/$ROOT_IF/channel_bonding
	     # 2 .Change the Default ssid family-test
	echo "Mytest" > $CONFIG_ROOT_DIR/$ROOT_IF/ssid 
	
	#Set the mode to AP 
	echo 0 >  $CONFIG_ROOT_DIR/$ROOT_IF/wlan_mode
	
	#PS : chnage the Band(1:B, 2:G, 4:A, 8:N, 64:AC) if you want ......
	# For  BGN mode(default): 11
	# echo 64 > $CONFIG_ROOT_DIR/$ROOT_IF/band
	
	
	#Start the Encryption here 
	#64-hex , default key is 098765421
	$SCRIPT_DIR/wep-64-hex.sh $ROOT_IF $1
		
	#start the WLAN script to set the value 
	$SCRIPT_DIR/init.sh
	
	#Set the IP to the interface here.
	$IFCONFIG $ROOT_IF 192.168.3.1/24
	
	echo "AP Mode Configuration Setting Completed Enjoy"
	
else 
	show_usage	
		
fi

