#Do not delete this line. If file starts with "BOARD", its file type treated as some BOA arch data type, then 
#while patch generation it treated as a some binary file and excludes this file. So, these changes can not 
#come in sdk patch.

BOARDNAME:=HGW

DEVICE_TYPE=router

#CPU_TYPE=cortex-a53
CPU_TYPE=armv8-a

#CFLAGS=-Os -pipe -march=armv8-a -mtune=cortex-a53 -fno-caller-saves
#CFLAGS=-Os -pipe -mcpu=armv8-a -fno-caller-saves
CFLAGS=-Os -pipe -fno-caller-saves

define Target/Description
	Build firmware images for HGW product
endef

