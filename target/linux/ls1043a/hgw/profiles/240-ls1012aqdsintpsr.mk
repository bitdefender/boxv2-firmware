#
# Copyright (C) 2008 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

define Profile/ls1012aqdsintpsr
	NAME:=LS1012AQDSINTPSR
endef

define Profile/ls1012aqdsintpsr/Description
	Reference design for LS1012A QDS Interposer board using Freescale LS1043 SoC
endef

$(eval $(call Profile,ls1012aqdsintpsr))

