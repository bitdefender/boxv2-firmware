#
# Copyright (C) 2008 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

define Profile/lsemu
	NAME:=EMU
endef

define Profile/lsemu/Description
	Reference design for EMU using Freescale LS1043 SoC
endef

$(eval $(call Profile,lsemu))

