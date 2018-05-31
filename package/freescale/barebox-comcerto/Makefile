#
# Copyright (C) 2010 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=barebox
PKG_VERSION:=2011
PKG_RELEASE:=06
PKG_SUBLEVEL:=0

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(BUILD_VARIANT)/$(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE).$(PKG_SUBLEVEL)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE).$(PKG_SUBLEVEL).tar.bz2
PKG_SOURCE_FILE:=$(TOPDIR)/dl/$(PKG_SOURCE)
PKG_MD5SUM:=
PKG_TARGETS:=bin

include $(INCLUDE_DIR)/package.mk

define barebox/Default
  TITLE:=
  CONFIG:=
  BIN_IMAGE:=
  ELF_IMAGE:=
endef

define barebox/uloaderc2kevm
  TITLE:=$(1) SKU Uloader for C2KEVM board
  CONFIG:=comcerto-2k_evm_$(if $(findstring nand,$(1)),nand_)uloader_defconfig
  BIN_IMAGE:=microloader-$(1)-c2kevm.bin
  ELF_IMAGE:=microloader-$(1)-c2kevm.elf
  PKG_BIN:=uloader.bin
  PKG_ELF:=barebox
  BUILD_VARIANT_PREFIX:=$(2)
  SKU_NO=$(if $(findstring nor-,$(1)),$(subst nor-,,$(1)),$(subst nand-,,$(1)))
endef

define barebox/uloaderc2kmfcnevm
  TITLE:=$(1) SKU Uloader for C2KMFCNEVM board
  CONFIG:=comcerto-2k_mfcnevm_$(if $(findstring nand,$(1)),nand_)uloader_defconfig
  BIN_IMAGE:=microloader-$(1)-c2kmfcnevm.bin
  ELF_IMAGE:=microloader-$(1)-c2kmfcnevm.elf
  PKG_BIN:=uloader.bin
  PKG_ELF:=barebox
  BUILD_VARIANT_PREFIX:=$(2)
  SKU_NO=$(if $(findstring nor-,$(1)),$(subst nor-,,$(1)),$(subst nand-,,$(1)))
endef

define barebox/uloaderboxv2ymodem
  TITLE:=$(1) SKU Uloader for BOXv2 board with YMODEM recovery download
  CONFIG:=comcerto-boxv2_$(if $(findstring nand,$(1)),nand_)ymodem_uloader_defconfig
  BIN_IMAGE:=microloader-$(1)-boxv2_ymodem.bin
  ELF_IMAGE:=microloader-$(1)-boxv2_ymodem.elf
  PKG_BIN:=uloader.bin
  PKG_ELF:=barebox
  BUILD_VARIANT_PREFIX:=$(2)
  SKU_NO=$(if $(findstring nor-,$(1)),$(subst nor-,,$(1)),$(subst nand-,,$(1)))
endef

define barebox/uloaderboxv2
  TITLE:=$(1) SKU Uloader for BOXv2 board
  CONFIG:=comcerto-boxv2_$(if $(findstring nand,$(1)),nand_)uloader_defconfig
  BIN_IMAGE:=microloader-$(1)-boxv2.bin
  ELF_IMAGE:=microloader-$(1)-boxv2.elf
  PKG_BIN:=uloader.bin
  PKG_ELF:=barebox
  BUILD_VARIANT_PREFIX:=$(2)
  SKU_NO=$(if $(findstring nor-,$(1)),$(subst nor-,,$(1)),$(subst nand-,,$(1)))
endef

define barebox/uloaderc2kasic
  TITLE:=$(1) SKU Uloader for C2KASIC board
  CONFIG:=comcerto-2k_asic_$(if $(findstring nand,$(1)),nand_)uloader_defconfig
  BIN_IMAGE:=microloader-$(1)-c2kasic.bin
  ELF_IMAGE:=microloader-$(1)-c2kasic.elf
  PKG_BIN:=uloader.bin
  PKG_ELF:=barebox
  BUILD_VARIANT_PREFIX:=$(2)
  SKU_NO=$(if $(findstring nor-,$(1)),$(subst nor-,,$(1)),$(subst nand-,,$(1)))
endef

define barebox/m86208uloaderc2kevm
  $(call barebox/uloaderc2kevm,nor-M86208,m8620)
endef
define barebox/m86207uloaderc2kevm
  $(call barebox/uloaderc2kevm,nor-M86207,m8620)
endef
define barebox/m86206uloaderc2kevm
  $(call barebox/uloaderc2kevm,nor-M86206,m8620)
endef
define barebox/m86204uloaderc2kevm
  $(call barebox/uloaderc2kevm,nor-M86204,m8620)
endef
define barebox/m86203uloaderc2kevm
  $(call barebox/uloaderc2kevm,nor-M86203,m8620)
endef
define barebox/m86202uloaderc2kevm
  $(call barebox/uloaderc2kevm,nor-M86202,m8620)
endef
define barebox/m86201uloaderc2kevm
  $(call barebox/uloaderc2kevm,nor-M86201,m8620)
endef
define barebox/m86208uloaderc2kmfcnevm
  $(call barebox/uloaderc2kmfcnevm,nor-M86208,m8620)
endef
define barebox/m86207uloaderc2kmfcnevm
  $(call barebox/uloaderc2kmfcnevm,nor-M86207,m8620)
endef
define barebox/m86206uloaderc2kmfcnevm
  $(call barebox/uloaderc2kmfcnevm,nor-M86206,m8620)
endef
define barebox/m86204uloaderc2kmfcnevm
  $(call barebox/uloaderc2kmfcnevm,nor-M86204,m8620)
endef
define barebox/m86203uloaderc2kmfcnevm
  $(call barebox/uloaderc2kmfcnevm,nor-M86203,m8620)
endef
define barebox/m86202uloaderc2kmfcnevm
  $(call barebox/uloaderc2kmfcnevm,nor-M86202,m8620)
endef
define barebox/m86201uloaderc2kmfcnevm
  $(call barebox/uloaderc2kmfcnevm,nor-M86201,m8620)
endef
define barebox/m86208uloaderc2kasic
  $(call barebox/uloaderc2kasic,nor-M86208,m8620)
endef
define barebox/m86207uloaderc2kasic
  $(call barebox/uloaderc2kasic,nor-M86207,m8620)
endef
define barebox/m86206uloaderc2kasic
  $(call barebox/uloaderc2kasic,nor-M86206,m8620)
endef
define barebox/m86204uloaderc2kasic
  $(call barebox/uloaderc2kasic,nor-M86204,m8620)
endef
define barebox/m86203uloaderc2kasic
  $(call barebox/uloaderc2kasic,nor-M86203,m8620)
endef
define barebox/m86202uloaderc2kasic
  $(call barebox/uloaderc2kasic,nor-M86202,m8620)
endef
define barebox/m86201uloaderc2kasic
  $(call barebox/uloaderc2kasic,nor-M86201,m8620)
endef

define barebox/m86298uloaderc2kevm
  $(call barebox/uloaderc2kevm,nor-M86298,m8629)
endef
define barebox/m86297uloaderc2kevm
  $(call barebox/uloaderc2kevm,nor-M86297,m8629)
endef
define barebox/m86296uloaderc2kevm
  $(call barebox/uloaderc2kevm,nor-M86296,m8629)
endef
define barebox/m86295uloaderc2kevm
  $(call barebox/uloaderc2kevm,nor-M86295,m8629)
endef
define barebox/m86294uloaderc2kevm
  $(call barebox/uloaderc2kevm,nor-M86294,m8629)
endef
define barebox/m86293uloaderc2kevm
  $(call barebox/uloaderc2kevm,nor-M86293,m8629)
endef
define barebox/m86292uloaderc2kevm
  $(call barebox/uloaderc2kevm,nor-M86292,m8629)
endef
define barebox/m86291uloaderc2kevm
  $(call barebox/uloaderc2kevm,nor-M86291,m8629)
endef

define barebox/m86298uloaderc2kmfcnevm
  $(call barebox/uloaderc2kmfcnevm,nor-M86298,m8629)
endef
define barebox/m86297uloaderc2kmfcnevm
  $(call barebox/uloaderc2kmfcnevm,nor-M86297,m8629)
endef
define barebox/m86296uloaderc2kmfcnevm
  $(call barebox/uloaderc2kmfcnevm,nor-M86296,m8629)
endef
define barebox/m86295uloaderc2kmfcnevm
  $(call barebox/uloaderc2kmfcnevm,nor-M86295,m8629)
endef
define barebox/m86294uloaderc2kmfcnevm
  $(call barebox/uloaderc2kmfcnevm,nor-M86294,m8629)
endef
define barebox/m86293uloaderc2kmfcnevm
  $(call barebox/uloaderc2kmfcnevm,nor-M86293,m8629)
endef
define barebox/m86292uloaderc2kmfcnevm
  $(call barebox/uloaderc2kmfcnevm,nor-M86292,m8629)
endef
define barebox/m86291uloaderc2kmfcnevm
  $(call barebox/uloaderc2kmfcnevm,nor-M86291,m8629)
endef

define barebox/m86298uloaderc2kasic
  $(call barebox/uloaderc2kasic,nor-M86298,m8629)
endef
define barebox/m86297uloaderc2kasic
  $(call barebox/uloaderc2kasic,nor-M86297,m8629)
endef
define barebox/m86296uloaderc2kasic
  $(call barebox/uloaderc2kasic,nor-M86296,m8629)
endef
define barebox/m86295uloaderc2kasic
  $(call barebox/uloaderc2kasic,nor-M86295,m8629)
endef
define barebox/m86294uloaderc2kasic
  $(call barebox/uloaderc2kasic,nor-M86294,m8629)
endef
define barebox/m86293uloaderc2kasic
  $(call barebox/uloaderc2kasic,nor-M86293,m8629)
endef
define barebox/m86292uloaderc2kasic
  $(call barebox/uloaderc2kasic,nor-M86292,m8629)
endef
define barebox/m86291uloaderc2kasic
  $(call barebox/uloaderc2kasic,nor-M86291,m8629)
endef

define barebox/m86262uloaderc2kevm
  $(call barebox/uloaderc2kevm,nor-M86262,m8626)
endef
define barebox/m86261uloaderc2kevm
  $(call barebox/uloaderc2kevm,nor-M86261,m8626)
endef
define barebox/m86261_nasuloaderc2kevm
  $(call barebox/uloaderc2kevm,nor-M86261_NAS,m8626)
endef
define barebox/m86260uloaderc2kevm
  $(call barebox/uloaderc2kevm,nor-M86260,m8626)
endef
define barebox/m86262uloaderc2kmfcnevm
  $(call barebox/uloaderc2kmfcnevm,nor-M86262,m8626)
endef
define barebox/m86261uloaderc2kmfcnevm
  $(call barebox/uloaderc2kmfcnevm,nor-M86261,m8626)
endef
define barebox/m86261_nasuloaderc2kmfcnevm
  $(call barebox/uloaderc2kmfcnevm,nor-M86261_NAS,m8626)
endef
define barebox/m86260uloaderc2kmfcnevm
  $(call barebox/uloaderc2kmfcnevm,nor-M86260,m8626)
endef

define barebox/m86262uloaderc2kasic
  $(call barebox/uloaderc2kasic,nor-M86262,m8626)
endef
define barebox/m86261uloaderc2kasic
  $(call barebox/uloaderc2kasic,nor-M86261,m8626)
endef
define barebox/m86261_nasuloaderc2kasic
  $(call barebox/uloaderc2kasic,nor-M86261_NAS,m8626)
endef
define barebox/m86260uloaderc2kasic
  $(call barebox/uloaderc2kasic,nor-M86260,m8626)
endef

## NAND definitions
define barebox/nandm86208uloaderc2kevm
  $(call barebox/uloaderc2kevm,nand-M86208,nandm8620)
endef
define barebox/nandm86207uloaderc2kevm
  $(call barebox/uloaderc2kevm,nand-M86207,nandm8620)
endef
define barebox/nandm86206uloaderc2kevm
  $(call barebox/uloaderc2kevm,nand-M86206,nandm8620)
endef
define barebox/nandm86204uloaderc2kevm
  $(call barebox/uloaderc2kevm,nand-M86204,nandm8620)
endef
define barebox/nandm86203uloaderc2kevm
  $(call barebox/uloaderc2kevm,nand-M86203,nandm8620)
endef
define barebox/nandm86202uloaderc2kevm
  $(call barebox/uloaderc2kevm,nand-M86202,nandm8620)
endef
define barebox/nandm86201uloaderc2kevm
  $(call barebox/uloaderc2kevm,nand-M86201,nandm8620)
endef
define barebox/nandm86208uloaderc2kmfcnevm
  $(call barebox/uloaderc2kmfcnevm,nand-M86208,nandm8620)
endef
define barebox/nandm86207uloaderc2kmfcnevm
  $(call barebox/uloaderc2kmfcnevm,nand-M86207,nandm8620)
endef
define barebox/nandm86206uloaderc2kmfcnevm
  $(call barebox/uloaderc2kmfcnevm,nand-M86206,nandm8620)
endef
define barebox/nandm86204uloaderc2kmfcnevm
  $(call barebox/uloaderc2kmfcnevm,nand-M86204,nandm8620)
endef
define barebox/nandm86203uloaderc2kmfcnevm
  $(call barebox/uloaderc2kmfcnevm,nand-M86203,nandm8620)
endef
define barebox/nandm86202uloaderc2kmfcnevm
  $(call barebox/uloaderc2kmfcnevm,nand-M86202,nandm8620)
endef
define barebox/nandm86201uloaderc2kmfcnevm
  $(call barebox/uloaderc2kmfcnevm,nand-M86201,nandm8620)
endef

define barebox/nandm86208uloaderboxv2ymodem
  $(call barebox/uloaderboxv2ymodem,nand-M86208,nandm8620)
endef

define barebox/nandm86208uloaderboxv2
  $(call barebox/uloaderboxv2,nand-M86208,nandm8620)
endef

define barebox/nandm86208uloaderc2kasic
  $(call barebox/uloaderc2kasic,nand-M86208,nandm8620)
endef
define barebox/nandm86207uloaderc2kasic
  $(call barebox/uloaderc2kasic,nand-M86207,nandm8620)
endef
define barebox/nandm86206uloaderc2kasic
  $(call barebox/uloaderc2kasic,nand-M86206,nandm8620)
endef
define barebox/nandm86204uloaderc2kasic
  $(call barebox/uloaderc2kasic,nand-M86204,nandm8620)
endef
define barebox/nandm86203uloaderc2kasic
  $(call barebox/uloaderc2kasic,nand-M86203,nandm8620)
endef
define barebox/nandm86202uloaderc2kasic
  $(call barebox/uloaderc2kasic,nand-M86202,nandm8620)
endef
define barebox/nandm86201uloaderc2kasic
  $(call barebox/uloaderc2kasic,nand-M86201,nandm8620)
endef

define barebox/nandm86298uloaderc2kevm
  $(call barebox/uloaderc2kevm,nand-M86298,nandm8629)
endef
define barebox/nandm86297uloaderc2kevm
  $(call barebox/uloaderc2kevm,nand-M86297,nandm8629)
endef
define barebox/nandm86296uloaderc2kevm
  $(call barebox/uloaderc2kevm,nand-M86296,nandm8629)
endef
define barebox/nandm86295uloaderc2kevm
  $(call barebox/uloaderc2kevm,nand-M86295,nandm8629)
endef
define barebox/nandm86294uloaderc2kevm
  $(call barebox/uloaderc2kevm,nand-M86294,nandm8629)
endef
define barebox/nandm86293uloaderc2kevm
  $(call barebox/uloaderc2kevm,nand-M86293,nandm8629)
endef
define barebox/nandm86292uloaderc2kevm
  $(call barebox/uloaderc2kevm,nand-M86292,nandm8629)
endef
define barebox/nandm86291uloaderc2kevm
  $(call barebox/uloaderc2kevm,nand-M86291,nandm8629)
endef
define barebox/nandm86298uloaderc2kmfcnevm
  $(call barebox/uloaderc2kmfcnevm,nand-M86298,nandm8629)
endef
define barebox/nandm86297uloaderc2kmfcnevm
  $(call barebox/uloaderc2kmfcnevm,nand-M86297,nandm8629)
endef
define barebox/nandm86296uloaderc2kmfcnevm
  $(call barebox/uloaderc2kmfcnevm,nand-M86296,nandm8629)
endef
define barebox/nandm86295uloaderc2kmfcnevm
  $(call barebox/uloaderc2kmfcnevm,nand-M86295,nandm8629)
endef
define barebox/nandm86294uloaderc2kmfcnevm
  $(call barebox/uloaderc2kmfcnevm,nand-M86294,nandm8629)
endef
define barebox/nandm86293uloaderc2kmfcnevm
  $(call barebox/uloaderc2kmfcnevm,nand-M86293,nandm8629)
endef
define barebox/nandm86292uloaderc2kmfcnevm
  $(call barebox/uloaderc2kmfcnevm,nand-M86292,nandm8629)
endef
define barebox/nandm86291uloaderc2kmfcnevm
  $(call barebox/uloaderc2kmfcnevm,nand-M86291,nandm8629)
endef

define barebox/nandm86298uloaderc2kasic
  $(call barebox/uloaderc2kasic,nand-M86298,nandm8629)
endef
define barebox/nandm86297uloaderc2kasic
  $(call barebox/uloaderc2kasic,nand-M86297,nandm8629)
endef
define barebox/nandm86296uloaderc2kasic
  $(call barebox/uloaderc2kasic,nand-M86296,nandm8629)
endef
define barebox/nandm86295uloaderc2kasic
  $(call barebox/uloaderc2kasic,nand-M86295,nandm8629)
endef
define barebox/nandm86294uloaderc2kasic
  $(call barebox/uloaderc2kasic,nand-M86294,nandm8629)
endef
define barebox/nandm86293uloaderc2kasic
  $(call barebox/uloaderc2kasic,nand-M86293,nandm8629)
endef
define barebox/nandm86292uloaderc2kasic
  $(call barebox/uloaderc2kasic,nand-M86292,nandm8629)
endef
define barebox/nandm86291uloaderc2kasic
  $(call barebox/uloaderc2kasic,nand-M86291,nandm8629)
endef

define barebox/nandm86262uloaderc2kevm
  $(call barebox/uloaderc2kevm,nand-M86262,nandm8626)
endef
define barebox/nandm86261uloaderc2kevm
  $(call barebox/uloaderc2kevm,nand-M86261,nandm8626)
endef
define barebox/nandm86261_nasuloaderc2kevm
  $(call barebox/uloaderc2kevm,nand-M86261_NAS,nandm8626)
endef
define barebox/nandm86260uloaderc2kevm
  $(call barebox/uloaderc2kevm,nand-M86260,nandm8626)
endef
define barebox/nandm86262uloaderc2kmfcnevm
  $(call barebox/uloaderc2kmfcnevm,nand-M86262,nandm8626)
endef
define barebox/nandm86261uloaderc2kmfcnevm
  $(call barebox/uloaderc2kmfcnevm,nand-M86261,nandm8626)
endef
define barebox/nandm86261_nasuloaderc2kmfcnevm
  $(call barebox/uloaderc2kmfcnevm,nand-M86261_NAS,nandm8626)
endef
define barebox/nandm86260uloaderc2kmfcnevm
  $(call barebox/uloaderc2kmfcnevm,nand-M86260,nandm8626)
endef

define barebox/nandm86262uloaderc2kasic
  $(call barebox/uloaderc2kasic,nand-M86262,nandm8626)
endef
define barebox/nandm86261uloaderc2kasic
  $(call barebox/uloaderc2kasic,nand-M86261,nandm8626)
endef
define barebox/nandm86261_nasuloaderc2kasic
  $(call barebox/uloaderc2kasic,nand-M86261_NAS,nandm8626)
endef
define barebox/nandm86260uloaderc2kasic
  $(call barebox/uloaderc2kasic,nand-M86260,nandm8626)
endef

define barebox/bareboxc2kevm
  TITLE:=Barebox for C2KEVM board.
  CONFIG:=comcerto-2k_evm_defconfig
  BIN_IMAGE:=barebox-c2kevm.bin
  ELF_IMAGE:=barebox-c2kevm.elf
  PKG_BIN:=barebox.bin
  PKG_ELF:=barebox
endef

define barebox/bareboxc2kmfcnevm
  TITLE:=Barebox for C2KMFCNEVM board.
  CONFIG:=comcerto-2k_mfcnevm_defconfig
  BIN_IMAGE:=barebox-c2kmfcnevm.bin
  ELF_IMAGE:=barebox-c2kmfcnevm.elf
  PKG_BIN:=barebox.bin
  PKG_ELF:=barebox
endef

define barebox/bareboxc2kasic
  TITLE:=Barebox for C2KASIC board.
  CONFIG:=comcerto-2k_asic_defconfig
  BIN_IMAGE:=barebox-c2kasic.bin
  ELF_IMAGE:=barebox-c2kasic.elf
  PKG_BIN:=barebox.bin
  PKG_ELF:=barebox
endef

define barebox/bareboxdiagsc2kevm
  TITLE:=Barebox DIAGS for C2KEVM board.
  CONFIG:=comcerto-2k_evm_diags_defconfig
  BIN_IMAGE:=barebox-diags-c2kevm.bin
  ELF_IMAGE:=barebox-diags-c2kevm.elf
  PKG_BIN:=barebox.bin
  PKG_ELF:=barebox
endef

define barebox/bareboxdiagsc2kmfcnevm
  TITLE:=Barebox DIAGS for C2KMFCNEVM board.
  CONFIG:=comcerto-2k_mfcnevm_diags_defconfig
  BIN_IMAGE:=barebox-diags-c2kmfcnevm.bin
  ELF_IMAGE:=barebox-diags-c2kmfcnevm.elf
  PKG_BIN:=barebox.bin
  PKG_ELF:=barebox
endef

define barebox/bareboxdiagsc2kasic
  TITLE:=Barebox DIAGS for C2KASIC board.
  CONFIG:=comcerto-2k_asic_diags_defconfig
  BIN_IMAGE:=barebox-diags-c2kasic.bin
  ELF_IMAGE:=barebox-diags-c2kasic.elf
  PKG_BIN:=barebox.bin
  PKG_ELF:=barebox
endef


# If we add/remove any more, need to add enable/disable configuration in config files.
SKUS:=m86208 m86207 m86206 m86204 m86203 m86202 m86201 m86298 m86297 m86296 m86295 m86294 m86293 m86292 m86291 m86262 m86261 m86260 m86261_nas
SKUS_BOXV2:=m86208
BOARDS:=c2kevm c2kmfcnevm c2kasic boxv2
BAREBOXES:=bareboxc2kevm bareboxc2kmfcnevm bareboxc2kasic bareboxdiagsc2kevm bareboxdiagsc2kmfcnevm bareboxdiagsc2kasic
BAREBOXES+= $(foreach barebox_sku,$(SKUS),$(barebox_sku)uloaderc2kevm)
BAREBOXES+= $(foreach barebox_sku,$(SKUS),$(barebox_sku)uloaderc2kmfcnevm)
BAREBOXES+= $(foreach barebox_sku,$(SKUS),$(barebox_sku)uloaderc2kasic)
BAREBOXES+= $(foreach barebox_sku,$(SKUS),nand$(barebox_sku)uloaderc2kevm)
BAREBOXES+= $(foreach barebox_sku,$(SKUS),nand$(barebox_sku)uloaderc2kmfcnevm)
BAREBOXES+= $(foreach barebox_sku,$(SKUS),nand$(barebox_sku)uloaderc2kasic)
BAREBOXES+= $(foreach barebox_sku,$(SKUS_BOXV2),nand$(barebox_sku)uloaderboxv2ymodem)
BAREBOXES+= $(foreach barebox_sku,$(SKUS_BOXV2),nand$(barebox_sku)uloaderboxv2)
define Package/barebox/template
define Package/barebox-comcerto-$(1)
  SECTION:=boot
  CATEGORY:=Boot Loaders
  TITLE:=$(2)
  DEPENDS:=@TARGET_comcerto2000 @(TARGET_comcerto2000_hgw_$(3)||TARGET_comcerto2000_nas_$(3)||TARGET_comcerto2000_hgw_nas_$(3)||TARGET_comcerto2000_gpp_$(3))
  URL:=http://barebox.org/download/
  DEFAULT:=y if (TARGET_comcerto2000 && (TARGET_comcerto2000_hgw_$(3)||TARGET_comcerto2000_nas_$(3)||TARGET_comcerto2000_hgw_nas_$(3)||TARGET_comcerto2000_gpp_$(3)))
  VARIANT:=$(1)
endef
endef

define BuildBareboxPackage
	$(eval $(barebox/Default))
	$(eval $(barebox/$(1)))
	$(call Package/barebox/template,$(1),$(TITLE),$(2))
endef

ifdef BUILD_VARIANT
$(eval $(call barebox/$(BUILD_VARIANT)))
BAREBOX_CONFIG:=$(if $(CONFIG),$(CONFIG),$(BUILD_VARIANT))
BAREBOX_BIN_IMAGE:=$(if $(BIN_IMAGE),$(BIN_IMAGE),openwrt-$(BOARD)-$(BUILD_VARIANT)-barebox.bin)
BAREBOX_ELF_IMAGE:=$(if $(ELF_IMAGE),$(ELF_IMAGE),openwrt-$(BOARD)-$(BUILD_VARIANT)-barebox.elf)
endif

ifeq ($(CONFIG_DEV_BAREBOX),y)
ifeq ($(CONFIG_DEV_BAREBOX_GITBRANCH), "")
define Build/Prepare
	$(eval $(call barebox/$(BUILD_VARIANT)))
	if [ ! -d "$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE).$(PKG_SUBLEVEL)" ]; then \
		mkdir -p "$(BUILD_DIR)";  \
		pushd "$(BUILD_DIR)";  \
		git clone ssh://$(CONFIG_ACTIVEDEV_GITUSERNAME)@$(CONFIG_ACTIVEDEV_GITROOTPATH)/$(CONFIG_DEV_BAREBOX_MODULENAME) $(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE).$(PKG_SUBLEVEL); \
		popd; \
	fi; \
	rm -rf "$(BUILD_DIR)/$(PKG_NAME)-$(BUILD_VARIANT)";  \
	mkdir "$(BUILD_DIR)/$(PKG_NAME)-$(BUILD_VARIANT)";  \
	if [[ "$(BUILD_VARIANT)" == *m862* ]]; then \
		if [ `find $(BUILD_DIR)/$(PKG_NAME)-$(BUILD_VARIANT_PREFIX)* -iname "buloader.bin" | wc -l` -eq 0 ]; then \
			cp -rf $(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE).$(PKG_SUBLEVEL) $(BUILD_DIR)/$(PKG_NAME)-$(BUILD_VARIANT); \
		else \
			if [[ "$(BUILD_VARIANT)" == *m86261_nas* ]]; then \
				cp -rf $(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE).$(PKG_SUBLEVEL) $(BUILD_DIR)/$(PKG_NAME)-$(BUILD_VARIANT); \
			else \
				mkdir -p $(BUILD_DIR)/$(PKG_NAME)-$(BUILD_VARIANT)/$(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE).$(PKG_SUBLEVEL); \
			fi; \
		fi; \
	else \
		cp -rf $(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE).$(PKG_SUBLEVEL) $(BUILD_DIR)/$(PKG_NAME)-$(BUILD_VARIANT); \
	fi
endef
else
define Build/Prepare
	$(eval $(call barebox/$(BUILD_VARIANT)))
	if [ ! -d "$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE).$(PKG_SUBLEVEL)" ]; then \
		mkdir -p "$(BUILD_DIR)";  \
		pushd "$(BUILD_DIR)";  \
		git clone ssh://$(CONFIG_ACTIVEDEV_GITUSERNAME)@$(CONFIG_ACTIVEDEV_GITROOTPATH)/$(CONFIG_DEV_BAREBOX_MODULENAME) $(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE).$(PKG_SUBLEVEL); \
		pushd "$(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE).$(PKG_SUBLEVEL)"; \
		if [ -n "$$$$(git tag | grep -w $(CONFIG_DEV_BAREBOX_GITBRANCH))" ]; then \
			git checkout -b $(CONFIG_DEV_BAREBOX_GITBRANCH) $(CONFIG_DEV_BAREBOX_GITBRANCH); \
		elif [ -n "$$$$(git branch -a | grep -w remotes\/origin\/$(CONFIG_DEV_BAREBOX_GITBRANCH))" ]; then \
			git checkout -b $(CONFIG_DEV_BAREBOX_GITBRANCH) origin/$(CONFIG_DEV_BAREBOX_GITBRANCH); \
		else \
			echo "Invalid tag or branch name. \"$(CONFIG_DEV_BAREBOX_GITBRANCH)\""; \
			exit 1; \
		fi; \
		popd; \
		popd; \
	fi; \
	rm -rf "$(BUILD_DIR)/$(PKG_NAME)-$(BUILD_VARIANT)";  \
	mkdir "$(BUILD_DIR)/$(PKG_NAME)-$(BUILD_VARIANT)";  \
	if [[ "$(BUILD_VARIANT)" == *m862* ]]; then \
		if [ `find $(BUILD_DIR)/$(PKG_NAME)-$(BUILD_VARIANT_PREFIX)* -iname "buloader.bin" | wc -l` -eq 0 ]; then \
			cp -rf $(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE).$(PKG_SUBLEVEL) $(BUILD_DIR)/$(PKG_NAME)-$(BUILD_VARIANT); \
		else \
			if [[ "$(BUILD_VARIANT)" == *m86261_nas* ]]; then \
				cp -rf $(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE).$(PKG_SUBLEVEL) $(BUILD_DIR)/$(PKG_NAME)-$(BUILD_VARIANT); \
			else \
				mkdir -p $(BUILD_DIR)/$(PKG_NAME)-$(BUILD_VARIANT)/$(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE).$(PKG_SUBLEVEL); \
			fi; \
		fi; \
	else \
		cp -rf $(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE).$(PKG_SUBLEVEL) $(BUILD_DIR)/$(PKG_NAME)-$(BUILD_VARIANT); \
	fi
endef
endif
else
PKG_SOURCE_URL:=http://barebox.org/download/
define Build/Prepare
	$(eval $(call barebox/$(BUILD_VARIANT)))
	if [ ! -d "$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE).$(PKG_SUBLEVEL)" ]; then \
		$(TAR) xfj $(PKG_SOURCE_FILE) -C $(BUILD_DIR); \
		if [ -d ./patches -a "$$$$(ls ./patches | wc -l)" -gt 0 ]; then \
			$(KPATCH) $(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE).$(PKG_SUBLEVEL) ./patches; \
		fi; \
		$(CP) ./files/fw/* $(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE).$(PKG_SUBLEVEL)/fw/ ; \
	fi; \
	rm -rf "$(BUILD_DIR)/$(PKG_NAME)-$(BUILD_VARIANT)";  \
	mkdir "$(BUILD_DIR)/$(PKG_NAME)-$(BUILD_VARIANT)";  \
	if [[ "$(BUILD_VARIANT)" == *m862* ]]; then \
		if [ `find $(BUILD_DIR)/$(PKG_NAME)-$(BUILD_VARIANT_PREFIX)* -iname "buloader.bin" | wc -l` -eq 0 ]; then \
			cp -rf $(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE).$(PKG_SUBLEVEL) $(BUILD_DIR)/$(PKG_NAME)-$(BUILD_VARIANT); \
		else \
			if [[ "$(BUILD_VARIANT)" == *m86261_nas* ]]; then \
				cp -rf $(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE).$(PKG_SUBLEVEL) $(BUILD_DIR)/$(PKG_NAME)-$(BUILD_VARIANT); \
			else \
				mkdir -p $(BUILD_DIR)/$(PKG_NAME)-$(BUILD_VARIANT)/$(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE).$(PKG_SUBLEVEL); \
			fi; \
		fi; \
	else \
		cp -rf $(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE).$(PKG_SUBLEVEL) $(BUILD_DIR)/$(PKG_NAME)-$(BUILD_VARIANT); \
	fi
endef
endif

define Build/Configure
endef

define gen_c2k_key
	pushd $(SCRIPT_DIR)/c2k_key_gen; \
	./key_gen.sh ; \
	popd
endef

uloader_hdr_gen_configuration="nonlegacy:null:::barebox.bin:"
barebox_hdr_gen_configuration="nonlegacy:null:::barebox.bin::"
ifeq ($(CONFIG_SECURE_BOOT),y)
ifeq ($(CONFIG_SECURE_BOOT_NULL),y)
	uloader_hdr_gen_configuration="nonlegacy:null:::barebox.bin:"
	barebox_hdr_gen_configuration="nonlegacy:null:::barebox.bin::"
endif
ifeq ($(CONFIG_SECURE_BOOT_HASH),y)
	uloader_hdr_gen_configuration="nonlegacy:sha256:::barebox.bin:"
	barebox_hdr_gen_configuration="nonlegacy:sha256:::barebox.bin::"
endif
ifeq ($(CONFIG_SECURE_BOOT_RSA_HASH_INSERT_KEY),y)
	uloader_hdr_gen_configuration="nonlegacy:rsa:privatekey-2k.pem:insertkey:barebox.bin:"
	barebox_hdr_gen_configuration="nonlegacy:rsa:privatekey-2k.pem:insertkey:barebox.bin::"
endif
ifeq ($(CONFIG_SECURE_BOOT_RSA_HASH_NO_KEY),y)
	uloader_hdr_gen_configuration="nonlegacy:rsa:privatekey-2k.pem:nokey:barebox.bin:"
	barebox_hdr_gen_configuration="nonlegacy:rsa:privatekey-2k.pem:nokey:barebox.bin::"
endif
ifeq ($(CONFIG_SECURE_BOOT_AES_RSA_HASH_INSERT_KEY),y)
	uloader_hdr_gen_configuration="nonlegacy:rsa:privatekey-2k.pem:insertkey:barebox.bin:"
	barebox_hdr_gen_configuration="nonlegacy:aes_rsa:privatekey-2k.pem:insertkey:barebox.bin:128:"
endif
ifeq ($(CONFIG_SECURE_BOOT_AES_RSA_HASH_NO_KEY),y)
	uloader_hdr_gen_configuration="nonlegacy:rsa:privatekey-2k.pem:nokey:barebox.bin:"
	barebox_hdr_gen_configuration="nonlegacy:aes_rsa:privatekey-2k.pem:nokey:barebox.bin:128:"
endif
endif

# This needs to be added in below section when generating barebox nand version
define Build/Compile/barebox
	$(eval $(call barebox/$(BUILD_VARIANT)))
	if [[ "$(BUILD_VARIANT)" == *m86261_nas* ]]; then \
		$(CP) $(PKG_BUILD_DIR)/arch/arm/configs/$(BAREBOX_CONFIG) $(PKG_BUILD_DIR)/.config ; \
		echo "# CONFIG_M86298 is not set" >> $(PKG_BUILD_DIR)/.config ; \
		echo "# CONFIG_M8629X is not set" >> $(PKG_BUILD_DIR)/.config ; \
		echo "CONFIG_$(SKU_NO)=y" >> $(PKG_BUILD_DIR)/.config ; \
		pushd $(BIN_DIR)/keys; \
		cp *.key *.rawkey *.pem publickeyhash-* $(PKG_BUILD_DIR)/tools/ImageGenarator/ ; \
		popd ; \
		head -n -1 $(PKG_BUILD_DIR)/tools/ImageGenarator/hdr_gen_cfg > $(PKG_BUILD_DIR)/tools/ImageGenarator/hdr_gen_cfg_tmp ; \
		mv $(PKG_BUILD_DIR)/tools/ImageGenarator/hdr_gen_cfg_tmp $(PKG_BUILD_DIR)/tools/ImageGenarator/hdr_gen_cfg ; \
		echo $(uloader_hdr_gen_configuration) >> $(PKG_BUILD_DIR)/tools/ImageGenarator/hdr_gen_cfg ; \
		$(MAKE) -C $(PKG_BUILD_DIR) CROSS_COMPILE=$(TARGET_CROSS) oldconfig ; \
		$(MAKE) -C $(PKG_BUILD_DIR) CROSS_COMPILE=$(TARGET_CROSS) ; \
		mv $(PKG_BUILD_DIR)/uloader.bin $(PKG_BUILD_DIR)/$(BIN_IMAGE) ; \
		mv $(PKG_BUILD_DIR)/barebox.bin $(PKG_BUILD_DIR)/barebox-m86261_nas.bin ; \
		mv $(PKG_BUILD_DIR)/barebox $(PKG_BUILD_DIR)/$(ELF_IMAGE) ; \
	else \
	if [[ "$(BUILD_VARIANT)" == *m862* ]]; then \
		if [ `find $(BUILD_DIR)/$(PKG_NAME)-$(BUILD_VARIANT_PREFIX)* -iname "buloader.bin" | wc -l` -gt 0 ]; then \
			mkdir -p $(BUILD_DIR)/$(PKG_NAME)-$(BUILD_VARIANT)/$(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE).$(PKG_SUBLEVEL)/tools ; \
			cp -rf $(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE).$(PKG_SUBLEVEL)/tools/ImageGenarator $(BUILD_DIR)/$(PKG_NAME)-$(BUILD_VARIANT)/$(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE).$(PKG_SUBLEVEL)/tools/ ; \
			cp -rf $(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE).$(PKG_SUBLEVEL)/uldr_sku_gen.sh $(BUILD_DIR)/$(PKG_NAME)-$(BUILD_VARIANT)/$(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE).$(PKG_SUBLEVEL)/ ; \
			cp -rf `find $(BUILD_DIR)/$(PKG_NAME)-$(BUILD_VARIANT_PREFIX)* -iname "barebox.bin"` $(BUILD_DIR)/$(PKG_NAME)-$(BUILD_VARIANT)/$(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE).$(PKG_SUBLEVEL)/ ; \
			cp -rf `find $(BUILD_DIR)/$(PKG_NAME)-$(BUILD_VARIANT_PREFIX)* -iname "barebox"` $(BUILD_DIR)/$(PKG_NAME)-$(BUILD_VARIANT)/$(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE).$(PKG_SUBLEVEL)/$(ELF_IMAGE) ; \
			pushd $(BIN_DIR)/keys; \
			cp *.key *.rawkey *.pem publickeyhash-* $(PKG_BUILD_DIR)/tools/ImageGenarator/ ; \
			popd ; \
			head -n -1 $(PKG_BUILD_DIR)/tools/ImageGenarator/hdr_gen_cfg > $(PKG_BUILD_DIR)/tools/ImageGenarator/hdr_gen_cfg_tmp ; \
			mv $(PKG_BUILD_DIR)/tools/ImageGenarator/hdr_gen_cfg_tmp $(PKG_BUILD_DIR)/tools/ImageGenarator/hdr_gen_cfg ; \
			echo $(uloader_hdr_gen_configuration) >> $(PKG_BUILD_DIR)/tools/ImageGenarator/hdr_gen_cfg ; \
			bash $(PKG_BUILD_DIR)/uldr_sku_gen.sh $(PKG_BUILD_DIR) $(BUILD_VARIANT) $(BIN_IMAGE) ; \
		else \
			$(CP) $(PKG_BUILD_DIR)/arch/arm/configs/$(BAREBOX_CONFIG) $(PKG_BUILD_DIR)/.config ; \
			echo "# CONFIG_M86298 is not set" >> $(PKG_BUILD_DIR)/.config ; \
			echo "# CONFIG_M8629X is not set" >> $(PKG_BUILD_DIR)/.config ; \
			echo "CONFIG_$(SKU_NO)=y" >> $(PKG_BUILD_DIR)/.config ; \
			pushd $(BIN_DIR)/keys; \
			cp *.key *.rawkey *.pem publickeyhash-* $(PKG_BUILD_DIR)/tools/ImageGenarator/ ; \
			popd ; \
			head -n -1 $(PKG_BUILD_DIR)/tools/ImageGenarator/hdr_gen_cfg > $(PKG_BUILD_DIR)/tools/ImageGenarator/hdr_gen_cfg_tmp ; \
			mv $(PKG_BUILD_DIR)/tools/ImageGenarator/hdr_gen_cfg_tmp $(PKG_BUILD_DIR)/tools/ImageGenarator/hdr_gen_cfg ; \
			echo $(uloader_hdr_gen_configuration) >> $(PKG_BUILD_DIR)/tools/ImageGenarator/hdr_gen_cfg ; \
			$(MAKE) -C $(PKG_BUILD_DIR) CROSS_COMPILE=$(TARGET_CROSS) oldconfig ; \
			$(MAKE) -C $(PKG_BUILD_DIR) CROSS_COMPILE=$(TARGET_CROSS) ; \
		fi; \
	else \
		$(CP) $(PKG_BUILD_DIR)/arch/arm/configs/$(BAREBOX_CONFIG) $(PKG_BUILD_DIR)/.config ; \
		pushd $(BIN_DIR)/keys; \
		cp *.key *.rawkey *.pem publickeyhash-* $(PKG_BUILD_DIR)/tools/ImageGenarator/ ; \
		popd ; \
		head -n -1 $(PKG_BUILD_DIR)/tools/ImageGenarator/hdr_gen_cfg > $(PKG_BUILD_DIR)/tools/ImageGenarator/hdr_gen_cfg_tmp ; \
		mv $(PKG_BUILD_DIR)/tools/ImageGenarator/hdr_gen_cfg_tmp $(PKG_BUILD_DIR)/tools/ImageGenarator/hdr_gen_cfg ; \
		echo $(barebox_hdr_gen_configuration) >> $(PKG_BUILD_DIR)/tools/ImageGenarator/hdr_gen_cfg ; \
		$(MAKE) -C $(PKG_BUILD_DIR) CROSS_COMPILE=$(TARGET_CROSS) oldconfig ; \
		$(MAKE) -C $(PKG_BUILD_DIR) CROSS_COMPILE=$(TARGET_CROSS) M_NO_UNALIGNED_ACCESS="y" ; \
	fi; \
	fi
endef

define Build/Compile
	$(call gen_c2k_key)
	$(call Build/Compile/barebox, $1)
endef

define Build/Clean
	$(call Build/Clean/Default)
	$(eval $(call barebox/$(BUILD_VARIANT)))
	rm -rf $(BUILD_DIR)/$(PKG_NAME)-$(BUILD_VARIANT)
	rm -rf $(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE).$(PKG_SUBLEVEL) 
endef

define Package/barebox/install/template
define Package/barebox-comcerto-$(1)/install
	if [[ "$(BUILD_VARIANT)" == *m862* ]]; then \
		if [ `find $(BUILD_DIR)/$(PKG_NAME)-$(BUILD_VARIANT_PREFIX)* -iname "$(BIN_IMAGE)" | wc -l` -gt 0 ]; then \
			$(CP) $(PKG_BUILD_DIR)/$(BIN_IMAGE) $$(1)/ ; \
			$(CP) $(PKG_BUILD_DIR)/$(ELF_IMAGE) $$(1)/ ; \
		else \
			$(CP) $(PKG_BUILD_DIR)/$(PKG_BIN) $$(1)/$(BIN_IMAGE) ; \
			$(CP) $(PKG_BUILD_DIR)/$(PKG_ELF) $$(1)/$(ELF_IMAGE) ; \
		fi; \
	else \
		$(CP) $(PKG_BUILD_DIR)/$(PKG_BIN) $$(1)/$(BIN_IMAGE) ; \
		$(CP) $(PKG_BUILD_DIR)/$(PKG_ELF) $$(1)/$(ELF_IMAGE) ; \
	fi
endef
endef

$(foreach u,$(BAREBOXES), \
	$(eval $(call Package/barebox/install/template,$(u),openwrt-$(BOARD)$(SUBTARGET)-$(u)-barebox.bin)) \
)

$(foreach u,$(BAREBOXES), \
	$(eval $(call BuildBareboxPackage,$(u),$(if $(findstring c2kevm,$(u)),c2kevm,$(if $(findstring c2kmfcnevm,$(u)),c2kmfcnevm,$(if $(findstring boxv2,$(u)),boxv2,c2kasic))))) \
	$(eval $(call BuildPackage,barebox-comcerto-$(u))) \
)

