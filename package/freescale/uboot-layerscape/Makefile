#
# Copyright (C) 2010 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=u-boot
PKG_VERSION:=2015
PKG_RELEASE:=01

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(BUILD_VARIANT)/$(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE).tar.bz2
PKG_MD5SUM:=7f08dc9e98a71652bd6968888ed6ec95 
PKG_TARGETS:=bin

include $(INCLUDE_DIR)/package.mk

define uboot/Default
  TITLE:=
  CONFIG:=
  IMAGE:=
endef

define uboot/ls1012a
  TITLE:=U-boot for the LS1012A board.
  CONFIG:=ls1012a_emu_config
  IMAGE:=uboot-ls1012a.bin
endef

define uboot/ls1012aqdsintpsr
  TITLE:=U-boot for the LS1012A QDS INTERPOSER Board
  CONFIG:=ls1012aqds_intpsr_config
  IMAGE:=uboot-ls1012aqdsintpsr.bin
endef

# If we add/remove any more, need to add enable/disable configuration in config files.
UBOOTS:=ls1012a ls1012aqdsintpsr

define Package/uboot/template
define Package/uboot-layerscape-$(1)
  SECTION:=boot
  CATEGORY:=Boot Loaders
  TITLE:=$(2)
  DEPENDS:=@TARGET_ls1012a_hgw_lsemu||(TARGET_ls1043a_hgw_ls1012aqdsintpsr)
  DEFAULT:=y if(TARGET_ls1012a_hgw_lsemu)
  URL:=http://www.denx.de/wiki/U-Boot
  VARIANT:=$(1)
endef
endef

define BuildUbootPackage
	$(eval $(uboot/Default))
	$(eval $(uboot/$(1)))
	$(call Package/uboot/template,$(1),$(TITLE))
endef


ifdef BUILD_VARIANT
$(eval $(call uboot/$(BUILD_VARIANT)))
UBOOT_CONFIG:=$(if $(CONFIG),$(CONFIG),$(BUILD_VARIANT))
UBOOT_IMAGE:=$(if $(IMAGE),$(IMAGE),openwrt-$(BOARD)-$(BUILD_VARIANT)-u-boot.bin)
endif

ifeq ($(CONFIG_DEV_U_BOOT_LAYERSCAPE),y)
ifeq ($(CONFIG_DEV_U_BOOT_LAYERSCAPE_GITBRANCH),"" )
define Build/Prepare
	mkdir -p "$(BUILD_DIR)/$(PKG_NAME)-$(BUILD_VARIANT)" && \
	pushd "$(BUILD_DIR)/$(PKG_NAME)-$(BUILD_VARIANT)" && \
	git clone ssh://$(CONFIG_ACTIVEDEV_GITUSERNAME)@$(CONFIG_ACTIVEDEV_GITROOTPATH)/$(CONFIG_DEV_U_BOOT_LAYERSCAPE_MODULENAME) $(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE) && \
	popd
	if [ -d ./patches -a "$$$$(ls ./patches | wc -l)" -gt 0 ]; then \
		$(KPATCH) $(PKG_BUILD_DIR) ./patches; \
	fi
endef
else
define Build/Prepare
	mkdir -p "$(BUILD_DIR)/$(PKG_NAME)-$(BUILD_VARIANT)" && \
	pushd "$(BUILD_DIR)/$(PKG_NAME)-$(BUILD_VARIANT)" && \
	git clone -b $(CONFIG_DEV_U_BOOT_LAYERSCAPE_GITBRANCH) ssh://$(CONFIG_ACTIVEDEV_GITUSERNAME)@$(CONFIG_ACTIVEDEV_GITROOTPATH)/$(CONFIG_DEV_U_BOOT_LAYERSCAPE_MODULENAME) $(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE) && \
	popd
	if [ -d ./patches -a "$$$$(ls ./patches | wc -l)" -gt 0 ]; then \
		$(KPATCH) $(PKG_BUILD_DIR) ./patches; \
	fi
endef
endif
else
PKG_SOURCE_URL:=ftp://ftp.denx.de/pub/u-boot
endif

define Build/Configure
endef



# This needs to be added in below section when generating uboot nand version
#	$(MAKE) -C $(PKG_BUILD_DIR) distclean
define Build/Compile/uboot
	$(MAKE) -C $(PKG_BUILD_DIR) $(UBOOT_CONFIG)
	$(MAKE) -C $(PKG_BUILD_DIR) CROSS_COMPILE=$(TARGET_CROSS)
endef

define Build/Compile
	
	$(call Build/Compile/uboot, $1)
endef

define Package/uboot/install/template
define Package/uboot-layerscape-$(1)/install
	$(CP) $(PKG_BUILD_DIR)/u-boot.bin $$(1)/
endef
endef

$(foreach u,$(UBOOTS), \
	$(eval $(call Package/uboot/install/template,$(u),openwrt-$(BOARD)$(SUBTARGET)-$(u)-u-boot.bin)) \
)

$(foreach u,$(UBOOTS), \
	$(eval $(call BuildUbootPackage,$(u))) \
	$(eval $(call BuildPackage,uboot-layerscape-$(u))) \
)
