#
# Copyright (C) 2010 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=u-boot
PKG_VERSION:=2013.01
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(BUILD_VARIANT)/$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.bz2
PKG_MD5SUM:=e58a8a7f78972248190d83de0dc362ce
PKG_TARGETS:=bin

include $(INCLUDE_DIR)/package.mk

define uboot/Default
  TITLE:=
  CONFIG:=
  IMAGE:=
endef

define uboot/c2kevm
  TITLE:=U-boot for the C2K EVM board.
  CONFIG:=c2kevm_config
  IMAGE:=uboot-c2kevm.bin
endef

define uboot/c2kmfcnevm
  TITLE:=U-boot for the C2K MFCNEVM board.
  CONFIG:=c2kmfcnevm_config
  IMAGE:=uboot-c2kmfcnevm.bin
endef

define uboot/boxv2
  TITLE:=U-boot for Bitdefender BOXv2 board.
  CONFIG:=boxv2_config
  IMAGE:=uboot-boxv2.bin
endef

define uboot/c2kasic
  TITLE:=U-boot for the C2K ASIC board.
  CONFIG:=c2kasic_config
  IMAGE:=uboot-c2kasic.bin
endef

# If we add/remove any more, need to add enable/disable configuration in config files.
UBOOTS:=c2kevm c2kasic c2kmfcnevm boxv2

define Package/uboot/template
define Package/uboot-comcerto-$(1)
  SECTION:=boot
  CATEGORY:=Boot Loaders
  TITLE:=$(2)
  DEPENDS:=@TARGET_comcerto2000_hgw_$(1)||TARGET_comcerto2000_nas_$(1)||TARGET_comcerto2000_hgw_nas_$(1)||TARGET_comcerto2000_gpp_$(1)
  URL:=http://www.denx.de/wiki/U-Boot
  DEFAULT:=y if (TARGET_comcerto2000)
  VARIANT:=$(1)
endef
endef

define BuildUbootPackage
	$(eval $(uboot/Default))
	$(eval $(uboot/$(1)))
	$(call Package/uboot/template,$(1),$(TITLE))
endef


uboot_hdr_gen_configuration="null:::u-boot.bin::"
ifeq ($(CONFIG_SECURE_BOOT),y)
ifeq ($(CONFIG_SECURE_BOOT_NULL),y)
	uboot_hdr_gen_configuration="null:::u-boot.bin::"
endif
ifeq ($(CONFIG_SECURE_BOOT_HASH),y)
	uboot_hdr_gen_configuration="sha256:::u-boot.bin::"
endif
ifeq ($(CONFIG_SECURE_BOOT_RSA_HASH_NO_KEY),y)
	uboot_hdr_gen_configuration="rsa:privatekey-2k.pem:nokey:u-boot.bin::"
endif
ifeq ($(CONFIG_SECURE_BOOT_RSA_HASH_INSERT_KEY),y)
	uboot_hdr_gen_configuration="rsa:privatekey-2k.pem:insertkey:u-boot.bin::"
endif
ifeq ($(CONFIG_SECURE_BOOT_AES_RSA_HASH_NO_KEY),y)
	uboot_hdr_gen_configuration="aes_rsa:privatekey-2k.pem:nokey:u-boot.bin:128:"
endif
ifeq ($(CONFIG_SECURE_BOOT_AES_RSA_HASH_INSERT_KEY),y)
	uboot_hdr_gen_configuration="aes_rsa:privatekey-2k.pem:insertkey:u-boot.bin:128:"
endif
endif

ifdef BUILD_VARIANT
$(eval $(call uboot/$(BUILD_VARIANT)))
UBOOT_CONFIG:=$(if $(CONFIG),$(CONFIG),$(BUILD_VARIANT))
UBOOT_IMAGE:=$(if $(IMAGE),$(IMAGE),openwrt-$(BOARD)-$(BUILD_VARIANT)-u-boot.bin)
endif

ifeq ($(CONFIG_DEV_U_BOOT),y)
ifeq ($(CONFIG_DEV_U_BOOT_GITBRANCH), "")
define Build/Prepare
	mkdir -p "$(BUILD_DIR)/$(PKG_NAME)-$(BUILD_VARIANT)" && \
	pushd "$(BUILD_DIR)/$(PKG_NAME)-$(BUILD_VARIANT)" && \
	git clone ssh://$(CONFIG_ACTIVEDEV_GITUSERNAME)@$(CONFIG_ACTIVEDEV_GITROOTPATH)/$(CONFIG_DEV_U_BOOT_MODULENAME) $(PKG_NAME)-$(PKG_VERSION); \
	popd
#	@if [ -d ./patches -a "$$$$(ls ./patches | wc -l)" -gt 0 ]; then \
#		$(KPATCH) $(PKG_BUILD_DIR) ./patches; \
#	fi
endef
else
define Build/Prepare
	mkdir -p "$(BUILD_DIR)/$(PKG_NAME)-$(BUILD_VARIANT)" && \
	pushd "$(BUILD_DIR)/$(PKG_NAME)-$(BUILD_VARIANT)" && \
	git clone ssh://$(CONFIG_ACTIVEDEV_GITUSERNAME)@$(CONFIG_ACTIVEDEV_GITROOTPATH)/$(CONFIG_DEV_U_BOOT_MODULENAME) $(PKG_NAME)-$(PKG_VERSION); \
	pushd "$(PKG_NAME)-$(PKG_VERSION)"; \
	if [ -n "$$$$(git tag | grep -w $(CONFIG_DEV_U_BOOT_GITBRANCH))" ]; then \
		git checkout -b $(CONFIG_DEV_U_BOOT_GITBRANCH) $(CONFIG_DEV_U_BOOT_GITBRANCH); \
	elif [ -n "$$$$(git branch -a | grep -w remotes\/origin\/$(CONFIG_DEV_U_BOOT_GITBRANCH))" ]; then \
		git checkout -b $(CONFIG_DEV_U_BOOT_GITBRANCH) origin/$(CONFIG_DEV_U_BOOT_GITBRANCH); \
	else \
		echo "Invalid tag or branch name. \"$(CONFIG_DEV_U_BOOT_GITBRANCH)\""; \
		exit 1; \
	fi; \
	popd; \
	popd
#	@if [ -d ./patches -a "$$$$(ls ./patches | wc -l)" -gt 0 ]; then \
#		$(KPATCH) $(PKG_BUILD_DIR) ./patches; \
#	fi
endef
endif
else
PKG_SOURCE_URL:=ftp://ftp.denx.de/pub/u-boot
endif

define Build/Configure
endef

define gen_c2k_key
	pushd $(SCRIPT_DIR)/c2k_key_gen; \
	./key_gen.sh ; \
	popd
endef


# This needs to be added in below section when generating uboot nand version
#	$(MAKE) -C $(PKG_BUILD_DIR) distclean
define Build/Compile/uboot
	pushd $(BIN_DIR)/keys ; \
	cp *.key *.rawkey *.pem publickeyhash-* $(PKG_BUILD_DIR)/tools/ImageGenarator/ ; \
	popd
	head -n -1 $(PKG_BUILD_DIR)/tools/ImageGenarator/hdr_gen_cfg > $(PKG_BUILD_DIR)/tools/ImageGenarator/hdr_gen_cfg_tmp
	mv $(PKG_BUILD_DIR)/tools/ImageGenarator/hdr_gen_cfg_tmp $(PKG_BUILD_DIR)/tools/ImageGenarator/hdr_gen_cfg
	echo $(uboot_hdr_gen_configuration) >> $(PKG_BUILD_DIR)/tools/ImageGenarator/hdr_gen_cfg
	$(MAKE) -C $(PKG_BUILD_DIR) CROSS_COMPILE=$(TARGET_CROSS) $(UBOOT_CONFIG)
	$(MAKE) -C $(PKG_BUILD_DIR) CROSS_COMPILE=$(TARGET_CROSS) M_NO_UNALIGNED_ACCESS="y"
endef

define Build/Compile
	$(call gen_c2k_key)
	$(call Build/Compile/uboot, $1)
endef

define Package/uboot/install/template
define Package/uboot-comcerto-$(1)/install
	$(CP) $(PKG_BUILD_DIR)/u-boot.bin $$(1)/
	$(CP) $(PKG_BUILD_DIR)/u-boot-nonsecureboot.bin $$(1)/
endef
endef

$(foreach u,$(UBOOTS), \
	$(eval $(call Package/uboot/install/template,$(u),openwrt-$(BOARD)$(SUBTARGET)-$(u)-u-boot.bin)) \
)

$(foreach u,$(UBOOTS), \
	$(eval $(call BuildUbootPackage,$(u))) \
	$(eval $(call BuildPackage,uboot-comcerto-$(u))) \
)
