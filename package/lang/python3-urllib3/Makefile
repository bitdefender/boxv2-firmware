# THIS IS A GENERATED FILE, PLEASE EDIT PyPItoMakefile.py
#
#
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=python3-urllib3
PKG_VERSION:=1.9.1
PKG_RELEASE:=1

PKG_SOURCE:=urllib3-1.9.1.tar.gz
PKG_SOURCE_URL:=https://pypi.python.org/packages/source/u/urllib3/
PKG_MD5SUM:=c9358c5a85dd6aa3942f5121efed064d
PKG_BUILD_DIR:=$(BUILD_DIR)/urllib3-$(PKG_VERSION)/

PKG_BUILD_DEPENDS:=python3-setuptools

include $(INCLUDE_DIR)/package.mk
$(call include_mk, python3-package.mk)

define Package/python3-urllib3
  SUBMENU:=Python
  SECTION:=lang
  CATEGORY:=Languages
  TITLE:=HTTP library with thread-safe connection pooling, file post, and more.
  URL:=http://urllib3.readthedocs.org/
  DEPENDS:=+python3
endef

define Package/python3-urllib3/description
 urllib3
 Highlights
 Re-use the same socket connection for multiple requests
 HTTPConnectionPool and HTTPSConnectionPool
 with optional client-side certificate verification.
 File posting encode_multipart_formdata.
 Built-in redirection and retries optional.
 Supports gzip and deflate decoding.
 Thread-safe and sanity-safe.
 Works with AppEngine gevent and eventlib.
endef

define Build/Compile
	$(call Build/Compile/PyMod,., \
		install --prefix="/usr" --root="$(PKG_INSTALL_DIR)" \
	)
endef

define Build/InstallDev
	$(INSTALL_DIR) $(STAGING_DIR)$(PYTHON_PKG_DIR)
	$(CP) \
		$(PKG_INSTALL_DIR)$(PYTHON_PKG_DIR)/* \
		$(STAGING_DIR)$(PYTHON_PKG_DIR)/
	[ ! -e $(PKG_INSTALL_DIR)/usr/include ] || $(CP) \
		$(PKG_INSTALL_DIR)/usr/include/* \
		$(STAGING_DIR)/usr/include/
endef

define Package/python3-urllib3/install
	$(INSTALL_DIR) $(1)$(PYTHON_PKG_DIR)
	$(CP) \
		$(PKG_INSTALL_DIR)$(PYTHON_PKG_DIR)/* \
		$(1)$(PYTHON_PKG_DIR)

endef

$(eval $(call BuildPackage,python3-urllib3))
