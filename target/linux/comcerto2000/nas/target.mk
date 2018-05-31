#Do not delete this line. If file starts with "BOARD", its file type treated as some BOA arch data type, then 
#while patch generation it treated as a some binary file and excludes this file. So, these changes can not 
#come in sdk patch.

BOARDNAME:=NAS
DEVICE_TYPE=nas
CPU_TYPE=cortex-a9
CFLAGS=-O3 -pipe -march=armv7-a -mtune=cortex-a9 -fno-caller-saves -mthumb


define Target/Description
	Build firmware images for NAS product
endef


