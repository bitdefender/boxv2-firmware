#
# Copyright (C) 2008 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

define Profile/c2kmfcnevm
	NAME:=MFCNEVM
endef

define Profile/c2kmfcnevm/Description
	Reference design for MFCN EVM using Mindspeed Comcerto-2000 SoC
endef

$(eval $(call Profile,c2kmfcnevm))

