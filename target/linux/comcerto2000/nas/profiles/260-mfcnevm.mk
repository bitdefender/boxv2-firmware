#
# Copyright (C) 2012 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

define Profile/c2kmfcnevm
	NAME:=MFCNEVM-NAS
endef

define Profile/c2kmfcnevm/Description
	NAS Reference design for MFCN EVM Board using Mindspeed Comcerto-2000 SoC
endef

$(eval $(call Profile,c2kmfcnevm))

