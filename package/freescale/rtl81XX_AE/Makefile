# 
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=rtl81XX_AE
PKG_REALTEK_VERSION:=3.1-20140102
PKG_MSPD_VERSION:=1.0
PKG_RELEASE:=1
PKG_VERSION:= $(PKG_REALTEK_VERSION)-$(PKG_MSPD_VERSION).$(PKG_RELEASE)

PKG_BUILD_DIR:=$(KERNEL_BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)
PKG_INSTALL_DIR:=$(PKG_BUILD_DIR)/ipkg-install

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_FILE:=$(TOPDIR)/dl/$(PKG_SOURCE)


PKG_BUILD_FROM_SOURCE:=$(shell if [ -e $(PKG_SOURCE_FILE) ]; then echo y; fi)
ifeq ($(CONFIG_DEV_REALTEK_RTL81XX_AE), y)
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


# This is Required for building the the driver for our C2K SDK environment
export CONFIG_PLATFORM := _MNDSPEED_

REALTEK_81XX_AE_AUTOLOAD:= \
	rtl8192cd

define KernelPackage/rtl81XX_AE
  CATEGORY:=Freescale Packages
  DEFAULT:=n
  DEPENDS:=+rtl81XX_AE
  TITLE:=Realtek WLAN driver (802.11 a/c/g/n)
  URL:=http://www.realtek.com.tw.com
  MAINTAINER:=Freescale Semiconductors
  FILES:= $(PKG_BUILD_DIR)/rtl8192cd.$(LINUX_KMOD_SUFFIX) 
  AUTOLOAD:=$(call AutoLoad,50,$(REALTEK_81XX_AE_AUTOLOAD))
endef

define KernelPackage/rtl81XX_AE/description
  This package contains station driver for Realtek Wi-Fi chipset (RTL81XX_AE).
endef

define Package/rtl81XX_AE
  CATEGORY:=Freescale Packages
  DEFAULT:=n
  TITLE:=Realtek WLAN driver (802.11 a/c/g/n) libraries
  URL:=http://www.realtek.com.tw.com
  MAINTAINER:=Freescale Semiconductors
endef

#If Development, we should download the version from our GIT instead of doing the generic process
ifeq ($(PKG_BUILD_FROM_SOURCE), y)
ifeq ($(CONFIG_DEV_REALTEK_RTL81XX_AE), y)
ifeq ($(CONFIG_DEV_REALTEK_RTL81XX_AE_GITBRANCH), "")

define Build/Prepare
	pushd "$(KERNEL_BUILD_DIR)" && \
	git clone ssh://$(CONFIG_ACTIVEDEV_GITUSERNAME)@$(CONFIG_ACTIVEDEV_GITROOTPATH)/$(CONFIG_DEV_REALTEK_RTL81XX_AE_GITTREE) $(PKG_NAME)-$(PKG_VERSION) && \
	popd
	@if [ -d ./patches -a "$$$$(ls ./patches | wc -l)" -gt 0 ]; then \
		$(KPATCH) $(PKG_BUILD_DIR) ./patches; \
	fi
endef

else
define Build/Prepare
	pushd "$(KERNEL_BUILD_DIR)" && \
	git clone ssh://$(CONFIG_ACTIVEDEV_GITUSERNAME)@$(CONFIG_ACTIVEDEV_GITROOTPATH)/$(CONFIG_DEV_REALTEK_RTL81XX_AE_GITTREE) $(PKG_NAME)-$(PKG_VERSION) && \
	pushd "$(PKG_NAME)-$(PKG_VERSION)" && \
	if [ -n "$$$$(git tag | grep -w $(CONFIG_DEV_REALTEK_RTL81XX_AE_GITBRANCH))" ]; then \
		git checkout -b $(CONFIG_DEV_REALTEK_RTL81XX_AE_GITBRANCH) $(CONFIG_DEV_REALTEK_RTL81XX_AE_GITBRANCH); \
	elif [ -n "$$$$(git branch -a | grep -w remotes\/origin\/$(CONFIG_DEV_REALTEK_RTL81XX_AE_GITBRANCH))" ]; then \
		git checkout -b $(CONFIG_DEV_REALTEK_RTL81XX_AE_GITBRANCH) origin/$(CONFIG_DEV_REALTEK_RTL81XX_AE_GITBRANCH); \
	else \
		echo "Invalid tag or branch name. \"$(CONFIG_DEV_REALTEK_RTL81XX_AE_GITBRANCH)\""; \
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

REALTEK_MAKEOPTS= DESTDIR="$(STAGING_DIR)" \
		ARCH="$(LINUX_KARCH)" \
		CROSS_COMPILE="$(TARGET_CROSS)" \
		TOOLPREFIX="$(KERNEL_CROSS)" \
		TOOLPATH="$(KERNEL_CROSS)" \
		KSRC="$(LINUX_DIR)"
#		  ARM_THUMB2="$(IS_KERNEL_THUMB)"  # Not supported Yet 

define Build/Compile
	echo "Realtek Driver compilation starts here,Be patient... "
	rm -rf $(PKG_INSTALL_DIR)
	mkdir -p $(PKG_INSTALL_DIR)
	# Deals with Driver 
	$(MAKE) -C $(PKG_BUILD_DIR)/DriverSrcPkg/driver/rtl8192cd $(REALTEK_MAKEOPTS) V=1
	$(CP) $(PKG_BUILD_DIR)/DriverSrcPkg/driver/rtl8192cd/rtl8192cd.$(LINUX_KMOD_SUFFIX) $(PKG_BUILD_DIR)
	
	# Deals with User binary 
	
	$(MAKE)  -C $(PKG_BUILD_DIR)/DriverSrcPkg/users $(REALTEK_MAKEOPTS) V=1
	echo "Realtek Driver Compilation Completed , Thank you for your patience... "
endef
else

#This is for  Release Build , This is belongs to NDA , so we will only release the binaries 
define Build/Prepare
	echo BUILD PREPARE 
endef

define Build/Compile
	# This is for Driver Module 
	$(CP) ./files/$(BIN_PROFILE_BUILD)/rtl8192cd-$(PKG_VERSION).$(LINUX_KMOD_SUFFIX) $(PKG_BUILD_DIR)/rtl8192cd.$(LINUX_KMOD_SUFFIX)

	# This is for User Space Binary file (Utility,Webs,flash etc....)
	mkdir -p $(PKG_BUILD_DIR)/DriverSrcPkg/users/bin
	$(CP)  ./files/$(BIN_PROFILE_BUILD)/webs $(PKG_BUILD_DIR)/DriverSrcPkg/users/bin/
	$(CP)  ./files/$(BIN_PROFILE_BUILD)/flash $(PKG_BUILD_DIR)/DriverSrcPkg/users/bin/
	$(CP)  ./files/$(BIN_PROFILE_BUILD)/auth $(PKG_BUILD_DIR)/DriverSrcPkg/users/bin/
	$(CP)  ./files/$(BIN_PROFILE_BUILD)/wscd $(PKG_BUILD_DIR)/DriverSrcPkg/users/bin/
	$(CP)  ./files/$(BIN_PROFILE_BUILD)/UDPserver $(PKG_BUILD_DIR)/DriverSrcPkg/users/bin/
	$(CP)  ./files/$(BIN_PROFILE_BUILD)/iwcontrol $(PKG_BUILD_DIR)/DriverSrcPkg/users/bin/
	$(CP)  ./files/$(BIN_PROFILE_BUILD)/iwpriv $(PKG_BUILD_DIR)/DriverSrcPkg/users/bin/
	$(CP)  ./files/$(BIN_PROFILE_BUILD)/iwlist $(PKG_BUILD_DIR)/DriverSrcPkg/users/bin/
	$(CP)  ./files/$(BIN_PROFILE_BUILD)/iwconfig $(PKG_BUILD_DIR)/DriverSrcPkg/users/bin/
	mkdir -p $(PKG_BUILD_DIR)/DriverSrcPkg/users/lib
	$(CP)  ./files/$(BIN_PROFILE_BUILD)/libiw.so.25 $(PKG_BUILD_DIR)/DriverSrcPkg/users/lib/
	$(CP)  ./files/ScriptFiles $(PKG_BUILD_DIR)/
	mkdir -p $(PKG_BUILD_DIR)/DriverSrcPkg/users/configuration-scripts
	rm -rf $(PKG_BUILD_DIR)/DriverSrcPkg/users/configuration-scripts/script
	mv  $(PKG_BUILD_DIR)/ScriptFiles/script $(PKG_BUILD_DIR)/DriverSrcPkg/users/configuration-scripts/
endef
endif

define Build/InstallDev
	echo InstallDev end
endef

define Build/UninstallDev
	echo UninstallDev end
endef


define Package/rtl81XX_AE/install
	echo Realtek_rtl81XX_AE installation start
	
	#Deals with  the Wirelesstool version 25
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_DIR) $(1)/usr/lib
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/DriverSrcPkg/users/bin/{iwconfig,iwpriv,iwlist} $(1)/usr/sbin/
	$(CP) $(PKG_BUILD_DIR)/DriverSrcPkg/users/lib/libiw.so.25 $(1)/usr/lib/
	$(LN) libiw.so.25 $(1)/usr/lib/libiw.so
	
	#Deals with the Proprietary realtek tools 
	$(INSTALL_DIR) $(1)/bin

	$(INSTALL_BIN) $(PKG_BUILD_DIR)/DriverSrcPkg/users/bin/{auth,flash,wscd,UDPserver,iwcontrol} $(1)/bin/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/DriverSrcPkg/users/bin/webs $(1)/bin/

	$(INSTALL_DIR) $(1)/etc
	$(CP) ./files/etc $(1)/

	#Deals with Realtek provided Script Files 
	$(INSTALL_DIR) $(1)/root
	$(CP) $(PKG_BUILD_DIR)/DriverSrcPkg/users/configuration-scripts/script $1/root/
	$(CP) $(PKG_BUILD_DIR)/ScriptFiles/*.sh $1/root/
	$(CP) ./files/test_client_ap_open.sh $(1)/root/
	$(CP) ./files/test_client_ap_wep.sh $(1)/root/
	$(CP) ./files/init.sh $(1)/root/

	echo Realtek_rtl81XX_AE-install end
endef
$(eval $(call KernelPackage,rtl81XX_AE))
$(eval $(call BuildPackage,rtl81XX_AE))
