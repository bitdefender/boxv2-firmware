# 
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
# $Id: Makefile,v 1.1.2.1 2007/03/16 10:25:22 yannick.vignon Exp $

include $(TOPDIR)/rules.mk

PKG_NAME:=mldproxy
PKG_VERSION:=20041012
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/Gateway
PKG_SOURCE:=Gateway_$(PKG_VERSION).tgz
PKG_SOURCE_URL:=http://clarinet.u-strasbg.fr/~frey/safari/multicast
PKG_CAT:=zcat

PKG_INSTALL_DIR:=$(PKG_BUILD_DIR)/ipkg-install

include $(INCLUDE_DIR)/package.mk

define Package/mldproxy
  SECTION:=ipv6
  CATEGORY:=IPv6
  TITLE:= MLDv1/MLDv2 proxy
  URL:=http://clarinet.u-strasbg.fr/~frey/safari/multicast
endef

define Package/mldproxy/Description
  Snoops MLDv1/MLDv2 requests and forwards them onto a given interface.
endef

define Package/mldproxy/conffiles
/etc/MLD_Proxy.cfg
endef

define Build/Configure
endef

define Build/Compile
	rm -rf $(PKG_INSTALL_DIR)
	mkdir -p $(PKG_INSTALL_DIR)/sbin
	$(MAKE) -C $(PKG_BUILD_DIR) \
		$(TARGET_CONFIGURE_OPTS) \
		CFLAGS="-Wall -O3" \
	$(STRIP) $(PKG_BUILD_DIR)/MLD_Proxy
	$(STRIP) $(PKG_BUILD_DIR)/show_stat
	cp $(PKG_BUILD_DIR)/MLD_Proxy $(PKG_INSTALL_DIR)/sbin/MLD_Proxy
	cp $(PKG_BUILD_DIR)/show_stat $(PKG_INSTALL_DIR)/sbin/MLD_show_stat
endef

define Package/mldproxy/install
	install -d -m0755 $(1)/etc
	install -d -m0755 $(1)/etc/init.d
	install -m0644 ./files/MLD_Proxy.cfg $(1)/etc/MLD_Proxy.cfg
	install -m0755 ./files/mldproxy.init $(1)/etc/init.d/mldproxy
	install -d -m0755 $(1)/sbin
	$(CP) $(PKG_INSTALL_DIR)/sbin/MLD_Proxy $(1)/sbin/
	$(CP) $(PKG_INSTALL_DIR)/sbin/MLD_show_stat $(1)/sbin/
endef

$(eval $(call BuildPackage,mldproxy))
