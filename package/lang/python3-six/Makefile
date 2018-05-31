# THIS IS A GENERATED FILE, PLEASE EDIT PyPItoMakefile.py
#
#
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=python3-six
PKG_VERSION:=1.8.0
PKG_RELEASE:=1

PKG_SOURCE:=six-1.8.0.tar.gz
PKG_SOURCE_URL:=https://pypi.python.org/packages/source/s/six/
PKG_MD5SUM:=1626eb24cc889110c38f7e786ec69885
PKG_BUILD_DIR:=$(BUILD_DIR)/six-$(PKG_VERSION)/

PKG_BUILD_DEPENDS:=python3-setuptools

include $(INCLUDE_DIR)/package.mk
$(call include_mk, python3-package.mk)

define Package/python3-six
  SUBMENU:=Python
  SECTION:=lang
  CATEGORY:=Languages
  TITLE:=Python 2 and 3 compatibility utilities
  URL:=http://pypi.python.org/pypi/six/
  DEPENDS:=+python3
endef

define Package/python3-six/description
 Six is a Python 2 and 3 compatibility library.  It provides utility functions
 for smoothing over the differences between the Python versions with the goal of
 writing Python code that is compatible on both Python versions.  See the
 documentation for more information on what is provided.
 Six supports every Python version since 2.5.  It is contained in only one Python
 file so it can be easily copied into your project. The copyright and license
 notice must be retained.
 Online documentation is at http://pythonhosted.org/six/.
 Bugs can be reported to http://bitbucket.org/gutworth/six.  The code can also be
 found there.
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

define Package/python3-six/install
	$(INSTALL_DIR) $(1)$(PYTHON_PKG_DIR)
	$(CP) \
		$(PKG_INSTALL_DIR)$(PYTHON_PKG_DIR)/* \
		$(1)$(PYTHON_PKG_DIR)

endef

$(eval $(call BuildPackage,python3-six))
