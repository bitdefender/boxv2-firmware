#
# Copyright (C) 2007-2012 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=samba4-server
PKG_VERSION:=4.0.0rc5
PKG_RELEASE:=1

ifeq ($(CONFIG_DEV_SAMBA4),)
PKG_SOURCE_URL_SUBDIR:=pre/samba4/rc/
PKG_SOURCE_URL:=https://ftp.samba.org/pub/samba/$(PKG_SOURCE_URL_SUBDIR)
PKG_SOURCE:=samba-$(PKG_VERSION).tar.gz
endif
PKG_BUILD_DIR:=$(BUILD_DIR)/samba-$(PKG_VERSION)
#PKG_MD5SUM:=24d4b715a46c5f111b08b87975a27b1e

#include $(INCLUDE_DIR)/package-version-override.mk
include $(INCLUDE_DIR)/package.mk

MAKE_PATH:=source3
CONFIGURE_PATH:=source3

PKG_BUILD_BIN:=$(PKG_BUILD_DIR)/$(MAKE_PATH)/bin

define Package/samba4-server
  SECTION:=net
  CATEGORY:=Network
  TITLE:=Samba 4.0 SMB/CIFS server
  URL:=http://www.samba.org/
  MENU:=1
endef

#define Package/samba4-server/config
#	source "$(SOURCE)/Config.in"
#	$(call Package/$(PKG_NAME)/override_source_path)
#endef

define Package/samba4-server/config
	config PACKAGE_SAMBA4_MAX_DEBUG_LEVEL
		int "Maximum level of compiled-in debug messages"
		depends on PACKAGE_samba4-server
		default -1

	config PACKAGE_SAMBA4_SMB_SPLICE
		bool "Freescale SMB Splice support"
		depends on PACKAGE_samba4-server
		default	y
endef

define Package/samba4-server/description
 The Samba software suite is a collection of programs that implements the
 SMB protocol for UNIX systems, allowing you to serve files and printers to
 Windows, NT, OS/2 and DOS clients. This protocol is sometimes also referred
 to as the LanManager or Netbios protocol.
endef

TARGET_CFLAGS += -DMAX_DEBUG_LEVEL=$(CONFIG_PACKAGE_SAMBA4_MAX_DEBUG_LEVEL) -D__location__=\\\"\\\" -ffunction-sections -fdata-sections

ifeq ($(CONFIG_PACKAGE_SAMBA4_SMB_SPLICE), y)
TARGET_CFLAGS += -DCONFIG_COMCERTO_SMB_SPLICE
endif

TARGET_CFLAGS += -DCONFIG_COMCERTO_READV -DCONFIG_COMCERTO_WRITEV

TARGET_LDFLAGS += -Wl,--gc-sections

CONFIGURE_VARS += \
	ac_cv_file__proc_sys_kernel_core_pattern=yes \
	libreplace_cv_HAVE_C99_VSNPRINTF=yes \
	libreplace_cv_HAVE_GETADDRINFO=yes \
	libreplace_cv_HAVE_IFACE_IFCONF=yes \
	LINUX_LFS_SUPPORT=yes \
	samba_cv_CC_NEGATIVE_ENUM_VALUES=yes \
	samba_cv_HAVE_GETTIMEOFDAY_TZ=yes \
	samba_cv_HAVE_IFACE_IFCONF=yes \
	samba_cv_HAVE_KERNEL_OPLOCKS_LINUX=yes \
	samba_cv_HAVE_SECURE_MKSTEMP=yes \
	samba_cv_HAVE_WRFILE_KEYTAB=no \
	samba_cv_HAVE_LINUX_SPLICE=yes \
	samba_cv_USE_SETREUID=yes \
	samba_cv_USE_SETRESUID=yes \
	samba_cv_have_setreuid=yes \
	samba_cv_have_setresuid=yes \
	ac_cv_header_zlib_h=no \
	samba_cv_zlib_1_2_3=no

CONFIGURE_ARGS += \
	--exec-prefix=/usr \
	--prefix=/ \
	--disable-avahi \
	--disable-cups \
	--disable-pie \
	--disable-relro \
	--disable-static \
	--disable-swat \
	--disable-shared-libs \
	--with-codepagedir=/etc/samba \
	--with-configdir=/etc/samba \
	--with-included-iniparser \
	--with-included-popt \
	--with-lockdir=/var/lock \
	--with-logfilebase=/var/log \
	--with-nmbdsocketdir=/var/nmbd \
	--with-piddir=/var/run \
	--with-privatedir=/etc/samba \
	--with-sendfile-support \
	--without-cluster-support \
	--without-ads \
	--without-krb5 \
	--without-ldap \
	--without-pam \
	--without-winbind \
	--without-aio-support \
	--without-libtdb \
	--without-libtalloc \
	--without-libnetapi \
	--without-libsmbclient \
	--without-libsmbsharemodes \
	--without-libaddns \
	--without-quotas \
	--with-shared-modules=pdb_tdbsam,pdb_wbc_sam,idmap_nss,nss_info_template,auth_winbind,auth_wbc,auth_domain

MAKE_FLAGS += DYNEXP= PICFLAG= MODULES=

#ifneq ($(CONFIG_samba4-server_USE_CUSTOM_SOURCE_DIR),y)

ifeq ($(CONFIG_DEV_SAMBA4), y)
ifeq ($(CONFIG_DEV_SAMBA4_GITBRANCH), "")
	CONFIG_DEV_SAMBA4_GITBRANCH:=master
endif

STAMP_PREPARED :=$(PKG_BUILD_DIR)/.prepared_git
define Build/Prepare
	@echo "--== Checking out sources from $(CONFIG_DEV_SAMBA4_GITBRANCH) ==-"
	pushd "$(BUILD_DIR)" && \
	git clone -b $(CONFIG_DEV_SAMBA4_GITBRANCH) ssh://$(CONFIG_ACTIVEDEV_GITUSERNAME)@$(CONFIG_ACTIVEDEV_GITROOTPATH)/$(CONFIG_DEV_SAMBA4_GITTREE) samba-$(PKG_VERSION) && \
	popd
	@if [ -d ./patches -a "$$$$(ls ./patches | wc -l)" -gt 0 ]; then \
		$(KPATCH) $(PKG_BUILD_DIR) ./patches; \
	fi
endef
endif

#endif

define Package/samba4-server/install
	$(INSTALL_DIR) $(1)/etc/{config,samba,init.d,rc.d}
	$(INSTALL_DIR) $(1)/www/cgi-bin/webif
	$(INSTALL_DATA) ./files/samba.config $(1)/etc/config/samba
	$(INSTALL_DATA) ./files/smb.conf.template $(1)/etc/samba
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/codepages/lowcase.dat $(1)/etc/samba
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/codepages/upcase.dat $(1)/etc/samba
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/codepages/valid.dat $(1)/etc/samba
	$(INSTALL_BIN) ./files/samba.init $(1)/etc/init.d/samba
ifeq ($(CONFIG_PACKAGE_webif),y)
	$(CP) ./files/www $(1)/
endif
	cd $(1)/etc; rm -f rc.d/S60samba; ln -s /etc/init.d/samba rc.d/S60samba
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_BIN)/samba_multicall $(1)/usr/sbin
	ln -sf samba_multicall $(1)/usr/sbin/smbd
	ln -sf samba_multicall $(1)/usr/sbin/nmbd
	ln -sf samba_multicall $(1)/usr/sbin/smbpasswd
endef

$(eval $(call BuildPackage,samba4-server))

