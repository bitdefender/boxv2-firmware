#!/bin/sh
#
# script file to start network
#
# Usage: init.sh {gw | ap} {all | bridge | wan}
#

##if [ $# -lt 2 ]; then echo "Usage: $0 {gw | ap} {all | bridge | wan}"; exit 1 ; fi

CONFIG_ROOT_DIR="/var/rtl8192c"


SCRIPT_DIR=`cat $CONFIG_ROOT_DIR/wifi_script_dir`
BIN_DIR=`cat $CONFIG_ROOT_DIR/wifi_bin_dir`

if [ -z "$SCRIPT_DIR" ] || [ -z "$BIN_DIR" ]; then
	exit 1;
fi
if [ ! -d "$SCRIPT_DIR" ]; then
	echo "ERROR: wifi_script_dir specify the path not exit."
	exit 1;
fi
if [ ! -d "$BIN_DIR" ]; then
	echo "ERROR: wifi_bin_dir specify the path not exit."
	exit 1;
fi

#PATH=$PATH:$BIN_DIR
#export PATH

START_BRIDGE=$SCRIPT_DIR/bridge.sh
START_WLAN_APP=$SCRIPT_DIR/wlanapp_8192c.sh
START_WLAN=$SCRIPT_DIR/wlan_8192c.sh
WLAN_PREFIX=wlan
# the following fields must manually set depends on system configuration. Not support auto config.
ROOT_WLAN=wlan0
ROOT_CONFIG_DIR=$CONFIG_ROOT_DIR/$ROOT_WLAN
WLAN_INTERFACE=$ROOT_WLAN
NUM_INTERFACE=`echo $WLAN_INTERFACE | wc -w`
#VIRTUAL_WLAN_INTERFACE="$ROOT_WLAN-va0 $ROOT_WLAN-va1 $ROOT_WLAN-va2 $ROOT_WLAN-va3"
VIRTUAL_WLAN_INTERFACE=""
VIRTUAL_NUM_INTERFACE=`echo $VIRTUAL_WLAN_INTERFACE | wc -w`
VXD_INTERFACE=
ALL_WLAN_INTERFACE="$WLAN_INTERFACE $VIRTUAL_WLAN_INTERFACE $VXD_INTERFACE"

FLASH_PROG=flash

export SCRIPT_DIR
export BIN_DIR
export WLAN_PREFIX
export ROOT_WLAN

# Query number of wlan interface
rtl_query_wlan_if() {
	NUM=0
	VIRTUAL_NUM=0
	VIRTUAL_WLAN_PREFIX=
	V_DATA=
	V_LINE=
	V_NAME=

	DATA=`ifconfig -a | grep $WLAN_PREFIX`
	LINE=`echo $DATA | grep $WLAN_PREFIX$NUM`
	NAME=`echo $LINE | cut -b -5`
	while [ -n "$NAME" ] 
	do
		WLAN_INTERFACE="$WLAN_INTERFACE $WLAN_PREFIX$NUM"
		ALL_WLAN_INTERFACE="$ALL_WLAN_INTERFACE $WLAN_PREFIX$NUM"

		VIRTUAL_WLAN_PREFIX="$WLAN_PREFIX$NUM-va"
		V_DATA=`ifconfig -a | grep $VIRTUAL_WLAN_PREFIX`
		V_LINE=`echo $V_DATA | grep $VIRTUAL_WLAN_PREFIX$VIRTUAL_NUM`
		V_NAME=`echo $V_LINE | cut -b -9`
		while [ -n "$V_NAME" ] 
		do
			VIRTUAL_WLAN_INTERFACE="$VIRTUAL_WLAN_INTERFACE $VIRTUAL_WLAN_PREFIX$VIRTUAL_NUM"
			ALL_WLAN_INTERFACE="$ALL_WLAN_INTERFACE $VIRTUAL_WLAN_PREFIX$VIRTUAL_NUM"
			VIRTUAL_NUM=`expr $VIRTUAL_NUM + 1`
			V_LINE=`echo $V_DATA | grep $VIRTUAL_WLAN_PREFIX$VIRTUAL_NUM`
			V_NAME=`echo $V_LINE | cut -b -9`
		done
		
		VXD_INTERFACE="$WLAN_PREFIX$NUM-vxd"
		V_DATA=`ifconfig -a | grep $VXD_INTERFACE`
		if [ -n "$V_DATA" ]; then
			VIRTUAL_WLAN_INTERFACE="$VIRTUAL_WLAN_INTERFACE $VXD_INTERFACE"
			ALL_WLAN_INTERFACE="$ALL_WLAN_INTERFACE $VXD_INTERFACE"
		fi
		##echo "<<<$VIRTUAL_WLAN_INTERFACE>>>"
		NUM=`expr $NUM + 1`
		LINE=`echo $DATA | grep $WLAN_PREFIX$NUM`
		NAME=`echo $LINE | cut -b -5`
	done
	NUM_INTERFACE=$NUM
	VIRTUAL_NUM_INTERFACE=$VIRTUAL_NUM
}

PARA0=$0
PARA1=$1
PARA2=$2
BR_INTERFACE=br0
BR_LAN1_INTERFACE=eth0
BR_LAN2_INTERFACE=eth1

BR_UTIL=brctl

ENABLE_BR=0

RPT_ENABLED=`cat $CONFIG_ROOT_DIR/repeater_enabled`

export BR_UTIL


# Generate WPS PIN number
rtl_generate_wps_pin() {
	GET_VALUE=`cat $ROOT_CONFIG_DIR/wsc_pin`
	if [ "$GET_VALUE" = "00000000" ]; then
		##echo "27006672" > $ROOT_CONFIG_DIR/wsc_pin
		$BIN_DIR/$FLASH_PROG gen-pin $ROOT_WLAN
		$BIN_DIR/$FLASH_PROG gen-pin $ROOT_WLAN-vxd
	fi
}

rtl_set_mac_addr() {
	# Set Ethernet 0 MAC address
	GET_VALUE=`cat $ROOT_CONFIG_DIR/nic0_addr`
	ELAN_MAC_ADDR=$GET_VALUE
	ifconfig $BR_LAN1_INTERFACE down
	ifconfig $BR_LAN1_INTERFACE hw ether $ELAN_MAC_ADDR
}


# Start WLAN interface
rtl_start_wlan_if() {
	for WLAN in $ALL_WLAN_INTERFACE; do
		EXT=`echo $WLAN | cut -b 7-9`
		echo 'Initialize '$WLAN' interface'
		ifconfig $WLAN down
		if [ -z "$EXT" ]; then		#ROOT_INTERFACE
			VAP=`echo $ALL_WLAN_INTERFACE | grep $WLAN-va`
			HAS_VAP=0
			if [ -n "$VAP" ]; then
				HAS_VAP=1
			fi
			iwpriv $WLAN set_mib vap_enable=$HAS_VAP
		fi
		if [ "$EXT" = "vxd" ]; then
			iwpriv $WLAN copy_mib
		fi
		echo "<<<$START_WLAN $WLAN>>>"
		$START_WLAN $WLAN
	done
}

# Enable WLAN interface
rtl_enable_wlan_if() {
	for WLAN in $ALL_WLAN_INTERFACE; do
		CONFIG_DIR=$CONFIG_ROOT_DIR/$WLAN
		WLAN_DISABLED_VALUE=`cat $CONFIG_DIR/wlan_disabled`
		if [ "$WLAN_DISABLED_VALUE" = 0 ]; then
			echo "<<<ENABLE $WLAN>>>"
			IP_ADDR=`cat $CONFIG_DIR/ip_addr`
			ifconfig $WLAN $IP_ADDR
			ifconfig $WLAN up
		fi
	done
}

rtl_start_no_gw() {
	echo "<<<$START_BRIDGE $BR_INTERFACE $BR_LAN1_INTERFACE $WLAN_INTERFACE $VIRTUAL_WLAN_INTERFACE>>>"
	$START_BRIDGE $BR_INTERFACE $BR_LAN1_INTERFACE $WLAN_INTERFACE $VIRTUAL_WLAN_INTERFACE

	echo "<<<$START_WLAN_APP start $WLAN_INTERFACE $VIRTUAL_WLAN_INTERFACE $BR_INTERFACE>>>"
	$START_WLAN_APP start $WLAN_INTERFACE $VIRTUAL_WLAN_INTERFACE $BR_INTERFACE
}


rtl_init() {
	echo "Init start....."
	killall webs 2> /dev/null
	$BIN_DIR/webs -x
#	rtl_query_wlan_if
##	rtl_set_mac_addr
	rtl_start_wlan_if
	
#	NO_EXIST=`which $BR_UTIL &> /dev/null; echo $?`
        NO_EXIT=`brctl`
        echo "NO_EXIST=$NO_EXIST=$?"
  
NO_EXIST=127
#	if [ "$NO_EXIST" != "0" ]; then
	if [ "$NO_EXIST" = "127" ]; then
		echo "Cannot find \"$BR_UTIL\" tool."
		rtl_enable_wlan_if
	else
		rtl_generate_wps_pin
		rtl_start_no_gw
	fi
}


rtl_init

