#
# Copyright (C) 2008 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

define Profile/lsqds
	NAME:=QDS
endef

define Profile/lsqds/Description
	Reference design for QDS using Freescale LS1043 SoC
endef

$(eval $(call Profile,lsqds))

