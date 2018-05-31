#
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=asterisk
PKG_VERSION:=1.8.2.3
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_CAT:=zcat

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)
PKG_INSTALL_DIR:=$(PKG_BUILD_DIR)/ipkg-install

PKG_BUILDDEP:=libncurses libpthread kmod-matisse vapi cmm libopenssl

INSTALL_APP:=app_confbridge.so app_dial.so app_macro.so app_parkandannounce.so app_playback.so app_record.so app_verbose.so
INSTALL_BRIDGE:=bridge_mspd.so
INSTALL_CHAN:=chan_bridge.so chan_local.so chan_mspd.so chan_sip.so
INSTALL_CODEC:=codec_a_mu.so codec_adpcm.so codec_alaw.so codec_g722.so codec_g726.so codec_gsm.so codec_lpc10.so codec_ulaw.so
INSTALL_FORMAT:=format_gsm.so format_g729.so format_g723.so
INSTALL_FUNC:=func_channel.so func_strings.so
INSTALL_PBX:=pbx_config.so
INSTALL_RES:=res_crypto.so res_musiconhold.so res_rtp_asterisk.so res_timing_pthread.so

INSTALL_ALL:=$(INSTALL_APP) $(INSTALL_BRIDGE) $(INSTALL_CHAN) $(INSTALL_CODEC) $(INSTALL_FORMAT) $(INSTALL_FUNC) $(INSTALL_PBX) $(INSTALL_RES)

include $(INCLUDE_DIR)/package.mk

############### Default Config file##############

ifeq ($(CONFIG_TARGET_comcerto2000_hgw_c2kevm)$(CONFIG_TARGET_comcerto2000_nas_c2kevm),y)
        CONFIG_FILE:=./files/asterisk.uci.c2kevm
        BOARD_NAME:=c2kevm
endif

ifeq ($(CONFIG_TARGET_comcerto2000_hgw_c2kmfcnevm)$(CONFIG_TARGET_comcerto2000_nas_c2kmfcnevm),y)
        CONFIG_FILE:=./files/asterisk.uci.c2kevm
        BOARD_NAME:=c2kmfcnevm
endif

ifeq ($(CONFIG_TARGET_comcerto2000_hgw_c2kasic)$(CONFIG_TARGET_comcerto2000_nas_c2kasic),y)
        CONFIG_FILE:=./files/asterisk.uci.c2kevm
        BOARD_NAME:=c2kasic
endif
#################################################

define Package/asterisk/Default
  SECTION:=net
  CATEGORY:=IP-PBX
  URL:=http://www.asterisk.org/
endef

define Package/asterisk/Default/description
	Asterisk is a complete PBX in software. It provides all of the features \\\
	you would expect from a PBX and more. Asterisk does voice over IP in three \\\
	protocols, and can interoperate with almost all standards-based telephony \\\
	equipment using relatively inexpensive hardware.
endef

define Package/asterisk
  $(call Package/asterisk/Default)
  DEPENDS:=+libncurses +libpthread +Tempo +kmod-matisse +vapi +kmod-csme +cmm +libopenssl +USE_UCLIBC:librt
  TITLE:=Complete open source PBX
endef

define Package/asterisk-voicemail
  $(call Package/asterisk/Default)
  DEPENDS:=+asterisk
  TITLE:=Voicemail support
endef

define Package/asterisk/description
	This package contains voicemail related modules for Asterisk.
endef

EXTRA_CFLAGS:= -I$(STAGING_DIR)/usr/include -I$(STAGING_DIR)/include -DUSE_DEPRECATED_G726 -DMSPD_CHANNEL_MODULE
EXTRA_LDFLAGS:= -L$(STAGING_DIR)/usr/lib -L$(STAGING_DIR)/lib

EXTRA_LDFLAGS+= -lm

TARGETS:=all install samples
OPTIONS=-Dlinux
TARGET_CFLAGS=-fhonour-copts
DEBUG:=n

ifeq ($(DEBUG), y)
	OPTIONS+=-ggdb -DDEBUG_THREADS -DDETECT_DEADLOCKS -DMALLOC_DEBUG
else
	OPTIONS+=-Os -DLOW_MEMORY
endif

ifeq ($(CONFIG_DEV_ASTERISK), y)
define Build/Prepare
	@echo "--== Checking out sources from $(CONFIG_DEV_ASTERISK_CVSBRANCH) ==-"
	pushd "$(BUILD_DIR)" && \
	cvs -z9 -d:pserver:$(CONFIG_ACTIVEDEV_CVSUSERNAME)@$(CONFIG_ACTIVEDEV_CVSROOTPATH) checkout -d $(PKG_NAME)-$(PKG_VERSION) -r $(CONFIG_DEV_ASTERISK_CVSBRANCH) $(CONFIG_DEV_ASTERISK_MODULENAME) && \
	popd
	@if [ -d ./patches -a "$$$$(ls ./patches | wc -l)" -gt 0 ]; then \
		$(KPATCH) $(PKG_BUILD_DIR) ./patches; \
	fi
ifeq ($(CONFIG_USE_UCLIBC),y)
	@if [ -d ./patches_uclibc-$(CONFIG_UCLIBC_VERSION) -a "$$$$(ls ./patches_uclibc-$(CONFIG_UCLIBC_VERSION) | wc -l)" -gt 0 ]; then \
		$(KPATCH) $(PKG_BUILD_DIR) ./patches_uclibc-$(CONFIG_UCLIBC_VERSION); \
	fi
endif
endef
else
PKG_SOURCE_URL:=http://downloads.asterisk.org/pub/telephony/asterisk/old-releases/
define Build/Prepare
	$(call Build/Prepare/Default,)	
ifeq ($(CONFIG_USE_UCLIBC),y)
	@if [ -d ./patches_uclibc-$(CONFIG_UCLIBC_VERSION) -a "$$$$(ls ./patches_uclibc-$(CONFIG_UCLIBC_VERSION) | wc -l)" -gt 0 ]; then \
		$(KPATCH) $(PKG_BUILD_DIR) ./patches_uclibc-$(CONFIG_UCLIBC_VERSION); \
	fi
endif
endef

endif

CONFIGURE_ARGS+=--disable-xmldoc \
		--without-sdl

define Build/Compile
	$(MAKE) -C "$(PKG_BUILD_DIR)" \
		CROSS_ARCH="Linux" \
		CROSS_COMPILE="$(TARGET_CROSS)" \
		CROSS_COMPILE_BIN="/void/" \
		CROSS_COMPILE_TARGET="/void/" \
		$(TARGET_CONFIGURE_OPTS) \
		OPTIMIZE="$(TARGET_CFLAGS)" \
		PROC="$(ARCH)" \
		DEBUG="" \
		BUILD_CC="$(HOSTCC)" \
		OPTIONS="$(OPTIONS)" \
		NOCRYPTO="yes" \
		EXTRA_CFLAGS="$(EXTRA_CFLAGS)" \
		EXTRA_LDFLAGS="$(EXTRA_LDFLAGS)" \
		EXTRA_APP_MODULES="$(EXTRA_APP_MODULES)" \
		EXTRA_CDR_MODULES="$(EXTRA_CDR_MODULES)" \
		EXTRA_CHAN_MODULES="$(EXTRA_CHAN_MODULES)" \
		EXTRA_CODEC_MODULES="$(EXTRA_CODEC_MODULES)" \
		EXTRA_RES_MODULES="$(EXTRA_RES_MODULES)" \
		DESTDIR="$(PKG_INSTALL_DIR)" \
		ASTVARLIBDIR="/usr/lib/asterisk" \
		ASTDATADIR="/usr/lib/asterisk" \
		$(EXTRA_DEFINES) \
		BUILD_FROM_OPENWRT="y" \
		$(TARGETS)
	rm -f $(PKG_INSTALL_DIR)/etc/asterisk/*.old
endef

define Package/asterisk/install
	install -d -m0755 $(1)/etc/asterisk
	install -m0644 $(PKG_INSTALL_DIR)/etc/asterisk/musiconhold.conf $(1)/etc/asterisk/
	install -m0644 $(PKG_INSTALL_DIR)/etc/asterisk/indications.conf $(1)/etc/asterisk/
	install -m0644 $(PKG_INSTALL_DIR)/etc/asterisk/modules.conf $(1)/etc/asterisk/
	install -m0644 $(PKG_INSTALL_DIR)/etc/asterisk/logger.conf $(1)/etc/asterisk/
	install -d -m0755 $(1)/usr/sbin
	install -m0755 $(PKG_INSTALL_DIR)/usr/sbin/asterisk $(1)/usr/sbin/
	install -d -m0755 $(1)/usr/lib/asterisk/sounds
	rm -rf $(PKG_INSTALL_DIR)/usr/lib/asterisk/moh/*
	cp ./files/manolo_camp-morning_coffee.gsm $(PKG_INSTALL_DIR)/usr/lib/asterisk/moh/
	cp ./files/manolo_camp-morning_coffee.g729 $(PKG_INSTALL_DIR)/usr/lib/asterisk/moh/
	cp ./files/manolo_camp-morning_coffee.g723 $(PKG_INSTALL_DIR)/usr/lib/asterisk/moh/
	tar zxvf ./files/asterisk-core-sounds-en-g723-1.4.20.tar.gz -C $(PKG_INSTALL_DIR)/usr/lib/asterisk/sounds/en
	tar zxvf ./files/asterisk-core-sounds-en-g729-1.4.20.tar.gz -C $(PKG_INSTALL_DIR)/usr/lib/asterisk/sounds/en
	find $(PKG_INSTALL_DIR)/usr/lib/asterisk/sounds -type f | xargs chmod 644
	rm -rf $(PKG_INSTALL_DIR)/usr/lib/asterisk/sounds/en/demo*
	rm -rf $(PKG_INSTALL_DIR)/usr/lib/asterisk/sounds/en/agent*
	rm -rf $(PKG_INSTALL_DIR)/usr/lib/asterisk/sounds/en/spy*
	rm -rf $(PKG_INSTALL_DIR)/usr/lib/asterisk/sounds/en/queue*
	rm -rf $(PKG_INSTALL_DIR)/usr/lib/asterisk/sounds/en/tt*
	rm -rf $(PKG_INSTALL_DIR)/usr/lib/asterisk/sounds/en/dir*
	rm -rf $(PKG_INSTALL_DIR)/usr/lib/asterisk/sounds/en/privacy*
	rm -rf $(PKG_INSTALL_DIR)/usr/lib/asterisk/sounds/en/auth*
	rm -rf $(PKG_INSTALL_DIR)/usr/lib/asterisk/sounds/en/CHANGES-asterisk-core-en-1.4.20
	rm -rf $(PKG_INSTALL_DIR)/usr/lib/asterisk/sounds/en/CREDITS-asterisk-core-en-1.4.20
	rm -rf $(PKG_INSTALL_DIR)/usr/lib/asterisk/sounds/en/ascending-2tone.*
	rm -rf $(PKG_INSTALL_DIR)/usr/lib/asterisk/sounds/en/core-sounds-en.txt
	rm -rf $(PKG_INSTALL_DIR)/usr/lib/asterisk/sounds/en/descending-2tone.*
	rm -rf $(PKG_INSTALL_DIR)/usr/lib/asterisk/sounds/en/hello-world.*
	rm -rf $(PKG_INSTALL_DIR)/usr/lib/asterisk/sounds/en/ss-noservice.*
	rm -rf $(PKG_INSTALL_DIR)/usr/lib/asterisk/sounds/en/hours.*
	rm -rf $(PKG_INSTALL_DIR)/usr/lib/asterisk/sounds/en/minutes.*
	rm -rf $(PKG_INSTALL_DIR)/usr/lib/asterisk/sounds/en/seconds.*
	rm -rf $(PKG_INSTALL_DIR)/usr/lib/asterisk/sounds/en/invalid.*
	rm -rf $(PKG_INSTALL_DIR)/usr/lib/asterisk/sounds/en/followme
	rm -rf $(PKG_INSTALL_DIR)/usr/lib/asterisk/sounds/en/dictate
	rm -rf $(PKG_INSTALL_DIR)/usr/lib/asterisk/sounds/en/letters
	rm -rf $(PKG_INSTALL_DIR)/usr/lib/asterisk/sounds/en/phonetic
	rm -rf $(PKG_INSTALL_DIR)/usr/lib/asterisk/sounds/en/silence
	cp -R $(PKG_INSTALL_DIR)/usr/lib/asterisk/moh $(1)/usr/lib/asterisk/
	cp -R $(PKG_INSTALL_DIR)/usr/lib/asterisk/sounds/en $(1)/usr/lib/asterisk/sounds
	install -d -m0755 $(1)/usr/lib/asterisk/modules
	for MODULE in $(INSTALL_ALL) ; do \
		install -m0755 $(PKG_INSTALL_DIR)/usr/lib/asterisk/modules/$$$${MODULE} $(1)/usr/lib/asterisk/modules/ ; \
	done
	rm -rf $(1)/usr/sbin/astgenkey
	$(CP) ./files/etc $(1)/
	install -d -m0755 $(1)/etc/config
	install -m0755  $(CONFIG_FILE) $(1)/etc/config/asterisk
	sed -i 's/option board_name[^][^]*/option board_name "$(BOARD_NAME)"/' $(1)/etc/config/asterisk
	@echo "--== ASTERISK with VAPI based MSPD channel module ==--"
	$(CP) ./files/lib $(1)/
	sed -i '/configure_asterisk/i \\t/lib/asterisk/configure_slic' $(1)/etc/init.d/asterisk
ifeq ($(CONFIG_PACKAGE_webif),y)
	$(CP) ./files/www $(1)/
endif
endef

define Package/asterisk-voicemail/install
	install -d -m0755 $(1)/etc/asterisk
	install -d -m0755 $(1)/usr/lib/asterisk/modules
	install -m0644 ./files/voicemail.conf $(1)/etc/asterisk/
	install -m0755 $(PKG_INSTALL_DIR)/usr/lib/asterisk/modules/res_smdi.so $(1)/usr/lib/asterisk/modules/
	install -m0755 $(PKG_INSTALL_DIR)/usr/lib/asterisk/modules/app_voicemail.so $(1)/usr/lib/asterisk/modules/
	install -d -m0755 $(1)/usr/lib/asterisk/sounds
	install -d -m0755 $(1)/tmp/spool/asterisk/voicemail/
	install -d -m0755 $(1)/tmp/spool/asterisk/voicemail/default
endef

$(eval $(call BuildPackage,asterisk))
$(eval $(call BuildPackage,asterisk-voicemail))
