#
# Copyright (C) 2008 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

define Profile/lsrdb
	NAME:=RDB
endef

define Profile/lsrdb/Description
	Reference design for RDB using Freescale LS1043 SoC
endef

$(eval $(call Profile,lsrdb))

