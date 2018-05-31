# 
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=atheros_lsdk_wlan
PKG_ATHEROS_VERSION:=10.2.85
PKG_MSPD_VERSION:=5.01
PKG_RELEASE:=1
PKG_VERSION:=$(PKG_ATHEROS_VERSION)-$(PKG_MSPD_VERSION).$(PKG_RELEASE)

PKG_ATHEROS_TAR_FILE:=$(PKG_ATHEROS_VERSION)-wlan-img.tgz
PKG_BUILD_DIR:=$(KERNEL_BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)
PKG_INSTALL_DIR:=$(PKG_BUILD_DIR)/ipkg-install

PKG_SOURCE_FILE:=$(TOPDIR)/dl/$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_BUILD_FROM_SOURCE:=$(shell if [ -e $(PKG_SOURCE_FILE) ]; then echo y; fi)
IS_KERNEL_THUMB=$(shell (grep "^CONFIG_THUMB2_KERNEL=" $(LINUX_DIR)/.config | cut -d'=' -f 2))

ifeq ($(CONFIG_DEV_ATHEROS_LSDK_WLAN), y)
  PKG_BUILD_FROM_SOURCE:=y
endif 
BIN_PROFILE_BUILD:=$(PROFILE)
ifeq ($(CONFIG_TARGET_comcerto2000_nas),y)
	BIN_PROFILE_BUILD:=$(PROFILE)-nas
	ifneq ($(CONFIG_COMCERTO_PAGE_SIZE_64K),y)
		BIN_PROFILE_BUILD:=$(BIN_PROFILE_BUILD)-4k
	endif
else
	ifeq ($(CONFIG_TARGET_comcerto2000_hgw_nas),y)
		BIN_PROFILE_BUILD:=$(PROFILE)-hgw_nas
	endif
endif
ifeq ($(CONFIG_LIBC),"uClibc")
	BIN_PROFILE_BUILD:=$(BIN_PROFILE_BUILD)-uclibc
endif

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/package/freescale/atheros-lsdk-wlan/files/config.fsl


export ATHEROSPATH=$(PKG_BUILD_DIR)/drivers
export PERF_PWR_OFFLOAD_DIR_PATH=$(PKG_BUILD_DIR)/drivers/wlan_modules/firmware

ifeq ($(ARCH),mips)
  HAL_TARGET:=mips-be-elf
endif
ifeq ($(ARCH),mipsel)
  HAL_TARGET:=mips-le-elf
endif
ifeq ($(ARCH),i386)
  HAL_TARGET:=i386-elf
endif
ifeq ($(ARCH),armeb)
  ifeq ($(word 1,$(subst ., ,$(GCC_VERSION))),4)
    HAL_TARGET:=armv6-be-elf
  else
    HAL_TARGET:=armv4-be-elf
  endif
endif
ifeq ($(ARCH),arm)
  ifeq ($(CONFIG_TARGET_comcerto2000), y)
    HAL_TARGET:=armv7-le-elf
  else
    ifeq ($(word 1,$(subst ., ,$(GCC_VERSION))),4)
      HAL_TARGET:=armv6-le-elf
    else
      HAL_TARGET:=armv4-le-elf
    endif
  endif
endif
ifeq ($(ARCH),powerpc)
  HAL_TARGET:=powerpc-be-elf
endif

ATHEROS_AUTOLOAD:= \
	adf \
	asf \
	ath_hal \
	ath_rate_atheros \
	ath_dfs \
	ath_dev \
	umac \
	ath_pktlog

################ OpenWRT definition ########################
define KernelPackage/atheros_lsdk_wlan
  CATEGORY:=Freescale Packages
  DEFAULT:=n
  DEPENDS:=+atheros_lsdk_wlan
  TITLE:=LSDK WLAN 802.11ac/n Wifi cards
  URL:=http://www.atheros.com/
  MAINTAINER:=Freescale Semiconductors
  FILES:= $(PKG_BUILD_DIR)/adf.$(LINUX_KMOD_SUFFIX) \
	$(PKG_BUILD_DIR)/asf.$(LINUX_KMOD_SUFFIX) \
	$(PKG_BUILD_DIR)/ath_hal.$(LINUX_KMOD_SUFFIX) \
	$(PKG_BUILD_DIR)/ath_rate_atheros.$(LINUX_KMOD_SUFFIX) \
	$(PKG_BUILD_DIR)/ath_dfs.$(LINUX_KMOD_SUFFIX) \
	$(PKG_BUILD_DIR)/ath_dev.$(LINUX_KMOD_SUFFIX) \
	$(PKG_BUILD_DIR)/umac.$(LINUX_KMOD_SUFFIX) \
	$(PKG_BUILD_DIR)/ath_pktlog.$(LINUX_KMOD_SUFFIX) 

  AUTOLOAD:=$(call AutoLoad,09,$(ATHEROS_AUTOLOAD))
endef

define KernelPackage/atheros_lsdk_wlan/description
  This package contains a driver for Atheros cards.
endef

define Package/atheros_lsdk_wlan
  CATEGORY:=Freescale Packages
  DEFAULT:=n
  TITLE:=LSDK WLAN 802.11ac/n Wifi cards libraries
  URL:=http://www.atheros.com/
  MAINTAINER:=Freescale Semiconductors
endef

ifeq ($(PKG_BUILD_FROM_SOURCE), y)
ifeq ($(CONFIG_DEV_ATHEROS_LSDK_WLAN), y)
ifeq ($(CONFIG_DEV_ATHEROS_LSDK_WLAN_GITBRANCH), "")

define Build/Prepare
	pushd "$(KERNEL_BUILD_DIR)" &&\
	git clone ssh://$(CONFIG_ACTIVEDEV_GITUSERNAME)@$(CONFIG_ACTIVEDEV_GITROOTPATH)/$(CONFIG_DEV_ATHEROS_LSDK_WLAN_GITTREE) $(PKG_NAME)-$(PKG_VERSION) && \
	popd

	@if [ -d ./patches -a "$$$$(ls ./patches | wc -l)" -gt 0 ]; then \
		$(KPATCH) $(PKG_BUILD_DIR) ./patches; \
	fi
endef

else
define Build/Prepare
	pushd "$(KERNEL_BUILD_DIR)" &&\
	git clone ssh://$(CONFIG_ACTIVEDEV_GITUSERNAME)@$(CONFIG_ACTIVEDEV_GITROOTPATH)/$(CONFIG_DEV_ATHEROS_LSDK_WLAN_GITTREE) $(PKG_NAME)-$(PKG_VERSION) && \
	pushd "$(PKG_NAME)-$(PKG_VERSION)" && \
	if [ -n "$$$$(git tag | grep -w $(CONFIG_DEV_ATHEROS_LSDK_WLAN_GITBRANCH))" ]; then \
		git checkout -b $(CONFIG_DEV_ATHEROS_LSDK_WLAN_GITBRANCH) $(CONFIG_DEV_ATHEROS_LSDK_WLAN_GITBRANCH); \
	elif [ -n "$$$$(git branch -a | grep -w remotes\/origin\/$(CONFIG_DEV_ATHEROS_LSDK_WLAN_GITBRANCH))" ]; then \
		git checkout -b $(CONFIG_DEV_ATHEROS_LSDK_WLAN_GITBRANCH) origin/$(CONFIG_DEV_ATHEROS_LSDK_WLAN_GITBRANCH); \
	else \
		echo "Invalid tag or branch name. \"$(CONFIG_DEV_ATHEROS_LSDK_WLAN_GITBRANCH)\""; \
		exit 1; \
	fi; \
	popd; \
	popd
	
	@if [ -d ./patches -a "$$$$(ls ./patches | wc -l)" -gt 0 ]; then \
		$(KPATCH) $(PKG_BUILD_DIR) ./patches; \
	fi
endef
endif
else
define Build/Prepare
	$(TAR) xfz $(PKG_SOURCE_FILE) -C $(KERNEL_BUILD_DIR)

	@if [ -d ./patches -a "$$$$(ls ./patches | wc -l)" -gt 0 ]; then \
		$(KPATCH) $(PKG_BUILD_DIR) ./patches; \
	fi
endef
endif

ATHEROS_MAKEOPTS= BOARD_TYPE="mspd" \
		MSPD_TOOLPREFIX="$(TARGET_CROSS)" \
		MSPD_KENELVER="$(LINUX_VERSION)" \
		MSPD_TARGETARCH="$(HAL_TARGET)" \
		MSPD_ATH_USE_NCNB="1" \
		SDK_MSPD_TOP_DIR="$(TOPDIR)" \
		MSPD_TOOLPATH="$(TOOLCHAIN_DIR)" \
		MSPD_KERNELPATH="$(LINUX_DIR)" \
		MSPD_BSP_ROOTFS_PATH="$(TARGET_DIR)" \
		ARM_THUMB2="$(IS_KERNEL_THUMB)" \
		TFTPPATH="$(PKG_BUILD_DIR\tftpboot)"


define Build/Compile
	echo Actual compile start
	cd $(PKG_BUILD_DIR)/build && $(MAKE) $(ATHEROS_MAKEOPTS)
	echo Actual compile end
	$(CP) $(PKG_BUILD_DIR)/drivers/wlan_modules/os/linux/ath_hal/ath_hal.$(LINUX_KMOD_SUFFIX) $(PKG_BUILD_DIR)
	$(CP) $(PKG_BUILD_DIR)/drivers/wlan_modules/lmac/dfs/ath_dfs.$(LINUX_KMOD_SUFFIX) $(PKG_BUILD_DIR)
	$(CP) $(PKG_BUILD_DIR)/drivers/wlan_modules/lmac/ath_dev/ath_dev.$(LINUX_KMOD_SUFFIX) $(PKG_BUILD_DIR)
	$(CP) $(PKG_BUILD_DIR)/drivers/wlan_modules/lmac/ratectrl/ath_rate_atheros.$(LINUX_KMOD_SUFFIX) $(PKG_BUILD_DIR)
	$(CP) $(PKG_BUILD_DIR)/drivers/wlan_modules/lmac/ath_pktlog/ath_pktlog.$(LINUX_KMOD_SUFFIX) $(PKG_BUILD_DIR)
	$(CP) $(PKG_BUILD_DIR)/drivers/wlan_modules/umac/umac.$(LINUX_KMOD_SUFFIX) $(PKG_BUILD_DIR)
	$(CP) $(PKG_BUILD_DIR)/drivers/wlan_modules/asf/asf.$(LINUX_KMOD_SUFFIX) $(PKG_BUILD_DIR)
	$(CP) $(PKG_BUILD_DIR)/drivers/wlan_modules/adf/adf.$(LINUX_KMOD_SUFFIX) $(PKG_BUILD_DIR)
endef

else
define Build/Prepare
	echo BUILD PREPARE
endef
define Build/Compile
	$(CP) ./files/$(BIN_PROFILE_BUILD)/ath_hal-$(PKG_VERSION).$(LINUX_KMOD_SUFFIX) $(PKG_BUILD_DIR)/ath_hal.$(LINUX_KMOD_SUFFIX)
	$(CP) ./files/$(BIN_PROFILE_BUILD)/ath_dfs-$(PKG_VERSION).$(LINUX_KMOD_SUFFIX) $(PKG_BUILD_DIR)/ath_dfs.$(LINUX_KMOD_SUFFIX)
	$(CP) ./files/$(BIN_PROFILE_BUILD)/ath_dev-$(PKG_VERSION).$(LINUX_KMOD_SUFFIX) $(PKG_BUILD_DIR)/ath_dev.$(LINUX_KMOD_SUFFIX)
	$(CP) ./files/$(BIN_PROFILE_BUILD)/ath_rate_atheros-$(PKG_VERSION).$(LINUX_KMOD_SUFFIX) $(PKG_BUILD_DIR)/ath_rate_atheros.$(LINUX_KMOD_SUFFIX)
	$(CP) ./files/$(BIN_PROFILE_BUILD)/ath_pktlog-$(PKG_VERSION).$(LINUX_KMOD_SUFFIX) $(PKG_BUILD_DIR)/ath_pktlog.$(LINUX_KMOD_SUFFIX)
	$(CP) ./files/$(BIN_PROFILE_BUILD)/umac-$(PKG_VERSION).$(LINUX_KMOD_SUFFIX) $(PKG_BUILD_DIR)/umac.$(LINUX_KMOD_SUFFIX)
	$(CP) ./files/$(BIN_PROFILE_BUILD)/asf-$(PKG_VERSION).$(LINUX_KMOD_SUFFIX) $(PKG_BUILD_DIR)/asf.$(LINUX_KMOD_SUFFIX)
	$(CP) ./files/$(BIN_PROFILE_BUILD)/adf-$(PKG_VERSION).$(LINUX_KMOD_SUFFIX) $(PKG_BUILD_DIR)/adf.$(LINUX_KMOD_SUFFIX)

	mkdir -p $(PKG_BUILD_DIR)/drivers/wlan_modules/os/linux/tools
	$(CP) -p ./files/$(BIN_PROFILE_BUILD)/80211stats $(PKG_BUILD_DIR)/drivers/wlan_modules/os/linux/tools/
	$(CP) -p ./files/$(BIN_PROFILE_BUILD)/athstats $(PKG_BUILD_DIR)/drivers/wlan_modules/os/linux/tools/
	$(CP) -p ./files/$(BIN_PROFILE_BUILD)/wlanconfig $(PKG_BUILD_DIR)/drivers/wlan_modules/os/linux/tools/

	mkdir -p $(PKG_BUILD_DIR)/apps/athr-hostap/hostapd
	$(CP) -p ./files/$(BIN_PROFILE_BUILD)/hostapd $(PKG_BUILD_DIR)/apps/athr-hostap/hostapd

	mkdir -p $(PKG_BUILD_DIR)/apps/$(WIRELESSTOOLS)
	$(CP) -p ./files/$(BIN_PROFILE_BUILD)/iwconfig $(PKG_BUILD_DIR)/apps/$(WIRELESSTOOLS)/
	$(CP) -p ./files/$(BIN_PROFILE_BUILD)/iwpriv $(PKG_BUILD_DIR)/apps/$(WIRELESSTOOLS)/
	$(CP) -p ./files/$(BIN_PROFILE_BUILD)/iwlist $(PKG_BUILD_DIR)/apps/$(WIRELESSTOOLS)/
	$(CP) -p ./files/$(BIN_PROFILE_BUILD)/apps_wireless_tools/*.so $(PKG_BUILD_DIR)/apps/$(WIRELESSTOOLS)/
	$(CP) -p ./files/$(BIN_PROFILE_BUILD)/apps_wireless_tools/libiw.so.29 $(PKG_BUILD_DIR)/apps/$(WIRELESSTOOLS)/

	mkdir -p $(PKG_BUILD_DIR)/drivers/wlan_modules
	$(CP) -r ./files/drivers/include $(PKG_BUILD_DIR)/drivers/wlan_modules/
	mkdir -p $(PKG_BUILD_DIR)/rootfs-mspd.optbuild
	$(CP) -r ./files/$(BIN_PROFILE_BUILD)/$(PKG_ATHEROS_TAR_FILE) $(PKG_BUILD_DIR)/rootfs-mspd.optbuild/
	tar -zxf $(PKG_BUILD_DIR)/rootfs-mspd.optbuild/$(PKG_ATHEROS_TAR_FILE) -C $(PKG_BUILD_DIR)/rootfs-mspd.optbuild/
endef
endif

define Build/InstallDev
	echo InstallDev start
	mkdir -p $(STAGING_DIR)/usr/include/atheros
	$(CP) $(PKG_BUILD_DIR)/drivers/wlan_modules/include $(STAGING_DIR)/usr/include/atheros/
#	mkdir -p $(STAGING_DIR)/usr/include/atheros/net80211
#	$(CP) $(PKG_BUILD_DIR)/wlan/linux/net80211/*.h $(STAGING_DIR)/usr/include/atheros/net80211/
	echo InstallDev end
endef

define Build/UninstallDev
	rm -rf	$(STAGING_DIR)/usr/include/atheros
endef

define Package/atheros_lsdk_wlan/install
	echo atheros_lsdk_wlan-install start
	$(INSTALL_DIR) $(1)/lib/wifi
	$(INSTALL_DATA) ./files/lib/wifi/atheros_lsdk_wlan.sh $(1)/lib/wifi
	$(INSTALL_DATA) ./files/lib/wifi/hostapd.sh $(1)/lib/wifi

	$(INSTALL_DIR) $(1)/usr/sbin
	$(CP) $(PKG_BUILD_DIR)/drivers/wlan_modules/os/linux/tools/{80211stats,athstats,wlanconfig} $(1)/usr/sbin/
 
# Install Hostapd and wireless_tool
 	
	$(CP) $(PKG_BUILD_DIR)/apps/athr-hostap/hostapd/hostapd $(1)/usr/sbin/
#	$(CP) $(PKG_BUILD_DIR)/apps/wpa2/wpatalk/wpatalk $(1)/usr/sbin/

	$(CP) $(PKG_BUILD_DIR)/apps/$(WIRELESSTOOLS)/iwconfig $(1)/usr/sbin/
	$(CP) $(PKG_BUILD_DIR)/apps/$(WIRELESSTOOLS)/iwlist $(1)/usr/sbin/
	$(CP) $(PKG_BUILD_DIR)/apps/$(WIRELESSTOOLS)/iwpriv  $(1)/usr/sbin/

	$(INSTALL_DIR) $(1)/etc/wpa2/
	$(CP) ./files/lib/wifi/security.conf $(1)/etc/wpa2/
	$(CP) $(PKG_BUILD_DIR)/apps/$(WIRELESSTOOLS)/*.so $(1)/lib/
	$(CP) $(PKG_BUILD_DIR)/apps/$(WIRELESSTOOLS)/libiw.so.29 $(1)/lib/
	$(LN) libiw.so.29 $(1)/lib/libiw.so
	
	echo atheros_lsdk_wlan-install end
	$(INSTALL_DIR) $(1)/bin
#	$(CP) $(PKG_BUILD_DIR)/rootfs-mspd.optbuild/bin/.dummy $(1)/bin/
	$(CP) $(PKG_BUILD_DIR)/rootfs-mspd.optbuild/etc/ath $(1)/etc/
	$(LN) /etc/ath $(1)/bin/
	$(INSTALL_DIR) $(1)/etc/rc.d
	$(CP) $(PKG_BUILD_DIR)/rootfs-mspd.optbuild/etc/rc.d/* $(1)/etc/rc.d/
	$(INSTALL_DIR) $(1)/lib/modules/$(LINUX_VERSION)/net
	$(LN) /lib/modules/$(LINUX_VERSION)/adf.ko $(1)/lib/modules/$(LINUX_VERSION)/net/adf.ko
	$(LN) /lib/modules/$(LINUX_VERSION)/asf.ko $(1)/lib/modules/$(LINUX_VERSION)/net/asf.ko
	$(LN) /lib/modules/$(LINUX_VERSION)/ath_dev.ko $(1)/lib/modules/$(LINUX_VERSION)/net/ath_dev.ko
	$(LN) /lib/modules/$(LINUX_VERSION)/ath_dfs.ko $(1)/lib/modules/$(LINUX_VERSION)/net/ath_dfs.ko
	$(LN) /lib/modules/$(LINUX_VERSION)/ath_hal.ko $(1)/lib/modules/$(LINUX_VERSION)/net/ath_hal.ko
	$(LN) /lib/modules/$(LINUX_VERSION)/ath_pktlog.ko $(1)/lib/modules/$(LINUX_VERSION)/net/ath_pktlog.ko
	$(LN) /lib/modules/$(LINUX_VERSION)/ath_rate_atheros.ko $(1)/lib/modules/$(LINUX_VERSION)/net/ath_rate_atheros.ko
	$(LN) /lib/modules/$(LINUX_VERSION)/umac.ko $(1)/lib/modules/$(LINUX_VERSION)/net/umac.ko

	$(LN) /etc/ath/apup $(1)/bin/apup
	$(LN) /etc/ath/activateVAP $(1)/bin/activateVAP
	$(LN) /etc/ath/apcfg $(1)/bin/apcfg
	$(LN) /etc/ath/apdown $(1)/bin/apdown
	$(LN) /etc/ath/killVAP $(1)/bin/killVAP
	$(LN) /etc/ath/wpscli $(1)/bin/wpscli
	$(LN) /etc/ath/prepareACFG $(1)/bin/prepareACFG
	$(LN) /etc/ath/makeVAP $(1)/bin/makeVAP

	$(INSTALL_DIR) $(1)/root
#	$(CP) $(PKG_BUILD_DIR)/rootfs-mspd.optbuild/root/.dummy $(1)/root/
#	$(CP) $(PKG_BUILD_DIR)/rootfs-mspd.optbuild/root/.configData $(1)/root/
#	$(CP) $(PKG_BUILD_DIR)/rootfs-mspd.optbuild/sbin/.dummy $(1)/usr/sbin/
	$(CP) $(PKG_BUILD_DIR)/rootfs-mspd.optbuild/sbin/* $(1)/usr/sbin/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/rootfs-mspd.optbuild/usr/www/cgi-bin/cgiMain $(1)/bin/cfg
endef


$(eval $(call KernelPackage,atheros_lsdk_wlan))
$(eval $(call BuildPackage,atheros_lsdk_wlan))
