#
# Copyright (C) 2012 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

define Profile/c2kasic
	NAME:=ASIC-NAS
endef

define Profile/c2kasic/Description
	NAS Reference design for ASIC Board using Mindspeed Comcerto-2000 SoC
endef

$(eval $(call Profile,c2kasic))

