#
# Copyright (C) 2008 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

define Profile/boxv2
	NAME:=BOXV2
endef

define Profile/boxv2/Description
	Bitdefender BOXv2
endef

$(eval $(call Profile,boxv2))

