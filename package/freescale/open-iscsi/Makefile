include $(TOPDIR)/rules.mk

PKG_NAME:=open-iscsi
PKG_VERSION:=2
PKG_RELEASE:=0-873

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE).tar.gz
PKG_SOURCE_URL:=http://www.mindspeed.com/
PKG_CAT:=zcat

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE)
PKG_INSTALL_DIR:=$(PKG_BUILD_DIR)/ipkg-install

include $(INCLUDE_DIR)/package.mk

define Package/open-iscsi
  SECTION:=Freescale Packages
  CATEGORY:=Freescale Packages
  TITLE:=Open ISCSI initiator
  URL:=http://www.mindspeed.com/
endef

define Package/open-iscsi/description
 OPEN ISCSI initiator.
endef


define Build/Configure
	(cd $(PKG_BUILD_DIR)/utils/open-isns ; \
		$(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS)" \
		CPPFLAGS="-I$(STAGING_DIR)/usr/include" \
		LDFLAGS="-L$(STAGING_DIR)/usr/lib" \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--program-prefix="" \
		--program-suffix="" \
		--prefix=/usr \
		--exec-prefix=/usr \
		--bindir=/usr/bin \
		--datadir=/usr/share \
		--includedir=/usr/include \
		--infodir=/usr/share/info \
		--libdir=/usr/lib \
		--libexecdir=/usr/lib \
		--localstatedir=/var \
		--mandir=/usr/share/man \
		--sbindir=/usr/sbin \
		--sysconfdir=/etc \
		$(DISABLE_NLS) \
		$(DISABLE_LARGEFILE) \
		--enable-shared \
		--enable-static \
		--with-security=no \
	);

endef

define Build/Compile
	$(call Build/Compile/Default,)
endef

define Package/open-iscsi/install
	mkdir -p $(1)/usr/sbin
	$(CP) $(PKG_BUILD_DIR)/usr/iscsid $(1)/usr/sbin
	$(CP) $(PKG_BUILD_DIR)/usr/iscsiadm $(1)/usr/sbin
	$(CP) $(PKG_BUILD_DIR)/usr/iscsistart $(1)/usr/sbin
	mkdir -p $(1)/etc/iscsi
	mkdir -p $(1)/sbin
	$(CP)  $(PKG_BUILD_DIR)/utils/iscsi-iname $(1)/sbin/
	$(CP)  $(PKG_BUILD_DIR)/etc/iscsid.conf $(1)/etc/iscsi/
	if [ ! -f $(1)/etc/iscsi/initiatorname.iscsi ]; then \
		echo "InitiatorName=`$(1)/sbin/iscsi-iname`" > $(1)/etc/iscsi/initiatorname.iscsi ; \
		echo "***************************************************" ; \
		echo "Setting InitiatorName to `cat $(1)/etc/iscsi/initiatorname.iscsi`" ; \
		echo "To override edit /etc/iscsi/initiatorname.iscsi" ; \
		echo "***************************************************" ; \
	fi
endef

$(eval $(call BuildPackage,open-iscsi))
