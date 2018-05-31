#
# Copyright (C) 2008 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

define Profile/c2kasic
	NAME:=ASIC
endef

define Profile/c2kasic/Description
	Reference design for ASIC using Mindspeed Comcerto-2000 SoC
endef

$(eval $(call Profile,c2kasic))

