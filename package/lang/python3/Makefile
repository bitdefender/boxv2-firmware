#
# Copyright (C) 2006-2012 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=python3
PY_VER:=3.4.2
PY_RC:=rc1
PKG_VERSION:=$(PY_VER)$(PY_RC)
PKG_RELEASE:=1

PKG_SOURCE:=Python-$(PKG_VERSION).tar.xz
PKG_SOURCE_URL:=http://www.python.org/ftp/python/$(PY_VER)
PKG_MD5SUM:=e5ca23606ee57b93dfc6c8d09d95cdbf

PKG_LICENSE:=PSF
PKG_LICENSE_FILES:=LICENSE Modules/_ctypes/libffi_msvc/LICENSE Modules/_ctypes/darwin/LICENSE Modules/_ctypes/libffi/LICENSE Modules/_ctypes/libffi_osx/LICENSE Tools/pybench/LICENSE

PKG_INSTALL:=1
PKG_BUILD_PARALLEL:=1
HOST_BUILD_PARALLEL:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/Python-$(PKG_VERSION)
HOST_BUILD_DIR:=$(BUILD_DIR_HOST)/Python-$(PKG_VERSION)

PKG_BUILD_DEPENDS:=python3/host

include $(INCLUDE_DIR)/host-build.mk
include $(INCLUDE_DIR)/package.mk
-include $(if $(DUMP),,./files/python3-package.mk)

define Package/python3/Default
  SUBMENU:=Python
  SECTION:=lang
  CATEGORY:=Languages
  TITLE:=Python $(PYTHON_VERSION) programming language
  URL:=http://www.python.org/
endef

define Package/python3/Default/description
 Python is a general-purpose, interpreted high-level programming language whose
 design philosophy emphasizes code readability. Its syntax is said to be clear
 and expressive. Python has a large and comprehensive standard library.
endef

define Package/python3
$(call Package/python3/Default)
  TITLE+= (full)
  DEPENDS:=+python3-mini
endef

define Package/python3/description
$(call Package/python3/Default/description)
 .
 This package contains the full Python install.
endef

define Package/python3-mini
$(call Package/python3/Default)
  TITLE+= (minimal)
  DEPENDS:=+libpthread +zlib
endef

define Package/python3-mini/description
$(call Package/python3/Default/description)
  .
  This package contains only a minimal Python install.
endef

define Package/python3-doc
$(call Package/python3/Default)
  TITLE:=Python support for pydoc and cgitb
  DEPENDS+=+python3
endef

#Needs threading
define Package/python3-bzip2
$(call Package/python3/Default)
  TITLE:=Python support for Bzip2
  DEPENDS+=+python3 +libbz2
endef

define Package/python3-expat
$(call Package/python3/Default)
  TITLE:=Python support for expat and plistlib
  DEPENDS+=+python3-mini +libexpat
endef

define Package/python3-ssl
$(call Package/python3/Default)
  TITLE:=Python support for ssl and hashlib
  DEPENDS+=+python3-mini +libopenssl
endef

# Needs datetime
define Package/python3-sqlite3
$(call Package/python3/Default)
  TITLE:=Python support for sqlite3
  DEPENDS+=+python3 +libsqlite3
endef

define Package/python3-gdbm
$(call Package/python3/Default)
  TITLE:=Python support for gdbm (dbm.gnu)
  DEPENDS+=+python3-mini +libgdbm
endef

define Package/python3-ndbm
$(call Package/python3/Default)
  TITLE:=Python support for ndbm
  DEPENDS+=+python3-mini +libdb47
endef

#Broken, see #8102
define Package/python3-readline
$(call Package/python3/Default)
  TITLE:=Python support for readline
  DEPENDS+=+python3-mini +python3-ncurses +libreadline @BROKEN
endef

define Package/python3-ncurses
$(call Package/python3/Default)
  TITLE:=Python support for ncurses
  DEPENDS+=+python3-mini +libncurses
endef

define Package/python3-ctypes
$(call Package/python3/Default)
  TITLE:=Python support for ctypes
  DEPENDS+=+python3-mini +libffi
endef

define Package/python3-2to3
$(call Package/python3/Default)
  TITLE:=Python support for 2to3
  DEPENDS+=+python3
endef

define Package/python3-testsuite
$(call Package/python3/Default)
  TITLE:=Testsuite for the Python standard library
  DEPENDS+=+python3
endef

#liblzma missing from new packages
#define Package/python3-lzma
#$(call Package/python3/Default)
#  TITLE:=Python support for lzma
#  DEPENDS+=+python3-mini +liblzma
#endef

MAKE_FLAGS:=\
	$(TARGET_CONFIGURE_OPTS) \
	DESTDIR="$(PKG_INSTALL_DIR)" \
	CROSS_COMPILE=yes \
	CFLAGS="$(TARGET_CFLAGS) -DNDEBUG -fno-inline" \
	LDFLAGS="-L$(PKG_BUILD_DIR) $(TARGET_LDFLAGS)" \
	LD="$(TARGET_CC)" \
	HOSTPYTHON=./hostpython3 \
	HOSTPGEN=./hostpgen3

ENABLE_IPV6:=
ifeq ($(CONFIG_IPV6),y)
	ENABLE_IPV6 += --enable-ipv6
endif

define Build/Configure
	-$(MAKE) -C $(PKG_BUILD_DIR) distclean
	(cd $(PKG_BUILD_DIR); autoreconf --force --install || exit 0)
	# The python executable needs to stay in the rootdir since its location will
	# be used to compute the path of the config files.
	$(CP) $(STAGING_DIR_HOST)/bin/pgen3 $(PKG_BUILD_DIR)/hostpgen3
	$(CP) $(STAGING_DIR_HOST)/bin/python$(PYTHON_BINABI) $(PKG_BUILD_DIR)/hostpython3
	$(call Build/Configure/Default, \
		--sysconfdir=/etc \
		--enable-shared \
		--without-cxx-main \
		--with-threads \
		--with-system-ffi="$(STAGING_DIR)/usr" \
		--without-ensurepip \
		$(ENABLE_IPV6) \
		ac_cv_have_chflags=no \
		ac_cv_have_lchflags=no \
		ac_cv_have_long_long_format=yes \
		ac_cv_buggy_getaddrinfo=no \
		ac_cv_file__dev_ptmx=yes \
		ac_cv_file__dev_ptc=no \
		OPT="$(TARGET_CFLAGS)" \
	)
endef

define Build/InstallDev
	$(INSTALL_DIR) $(2)/bin $(1)/usr/bin $(1)/usr/include $(1)/usr/lib
	$(INSTALL_DIR) $(STAGING_DIR)/mk/
	$(INSTALL_DATA) ./files/python3-package.mk $(STAGING_DIR)/mk/
	$(CP) \
		$(PKG_INSTALL_DIR)/usr/include/python$(PYTHON_BINABI) \
		$(1)/usr/include/
	$(CP) \
		$(STAGING_DIR_HOST)/lib/python$(PYTHON_VERSION) \
		$(PKG_BUILD_DIR)/libpython$(PYTHON_BINABI).a \
		$(1)/usr/lib/
	$(CP) \
		$(PKG_INSTALL_DIR)/usr/lib/python$(PYTHON_VERSION)/config-$(PYTHON_BINABI) \
		$(1)/usr/lib/python$(PYTHON_VERSION)/
	$(CP) \
		$(PKG_INSTALL_DIR)/usr/lib/libpython$(PYTHON_VERSION)* \
		$(1)/usr/lib/

	$(CP) \
		$(STAGING_DIR_HOST)/bin/python$(PYTHON_BINABI) \
		$(1)/usr/bin/hostpython3
	(cd $(2)/bin; \
	ln -sf ../../usr/bin/hostpython3 python$(PYTHON_BINABI); \
	ln -sf python$(PYTHON_BINABI) python3)

	$(CP) \
		$(STAGING_DIR_HOST)/bin/python$(PYTHON_BINABI)-config \
		$(2)/bin/
	$(SED) \
		's,^#!.*,#!/usr/bin/env python$(PYTHON_BINABI),g' \
		$(2)/bin/python$(PYTHON_BINABI)-config

	(cd $(2)/bin; \
	ln -sf python$(PYTHON_BINABI)-config python3-config;)
endef

define PyPackage/python3/filespec
+|/usr/lib/python$(PYTHON_VERSION)
-|/usr/lib/python$(PYTHON_VERSION)/config-$(PYTHON_BINABI)
-|/usr/lib/python$(PYTHON_VERSION)/distutils/command/wininst-*.exe
-|/usr/lib/python$(PYTHON_VERSION)/distutils/tests
-|/usr/lib/python$(PYTHON_VERSION)/idlelib
-|/usr/lib/python$(PYTHON_VERSION)/sqlite3
-|/usr/lib/python$(PYTHON_VERSION)/test
-|/usr/lib/python$(PYTHON_VERSION)/lib2to3
-|/usr/lib/python$(PYTHON_VERSION)/lib-dynload/_bz2.$(PYTHON_LIBABI).so
-|/usr/lib/python$(PYTHON_VERSION)/bz2.py
-|/usr/lib/python$(PYTHON_VERSION)/dbm/gnu.py
-|/usr/lib/python$(PYTHON_VERSION)/lib-dynload/_gdbm.$(PYTHON_LIBABI).so
-|/usr/lib/python$(PYTHON_VERSION)/dbm/ndbm.py
-|/usr/lib/python$(PYTHON_VERSION)/lib-dynload/_dbm.$(PYTHON_LIBABI).so
-|/usr/lib/python$(PYTHON_VERSION)/lib-dynload/_sqlite3.$(PYTHON_LIBABI).so
-|/usr/lib/python$(PYTHON_VERSION)/lib-dynload/_ssl.$(PYTHON_LIBABI).so
-|/usr/lib/python$(PYTHON_VERSION)/lib-dynload/pyexpat.$(PYTHON_LIBABI).so
-|/usr/lib/python$(PYTHON_VERSION)/pydoc_data
-|/usr/lib/python$(PYTHON_VERSION)/pydoc.py
-|/usr/lib/python$(PYTHON_VERSION)/lib-dynload/_testcapi.$(PYTHON_LIBABI).so
-|/usr/lib/python$(PYTHON_VERSION)/__future__.py
-|/usr/lib/python$(PYTHON_VERSION)/abc.py
-|/usr/lib/python$(PYTHON_VERSION)/codecs.py
-|/usr/lib/python$(PYTHON_VERSION)/compileall.py
-|/usr/lib/python$(PYTHON_VERSION)/imp.py
-|/usr/lib/python$(PYTHON_VERSION)/importlib
-|/usr/lib/python$(PYTHON_VERSION)/configparser.py
-|/usr/lib/python$(PYTHON_VERSION)/copy.py
-|/usr/lib/python$(PYTHON_VERSION)/copyreg.py
-|/usr/lib/python$(PYTHON_VERSION)/dis.py
-|/usr/lib/python$(PYTHON_VERSION)/encodings
-|/usr/lib/python$(PYTHON_VERSION)/fnmatch.py
-|/usr/lib/python$(PYTHON_VERSION)/genericpath.py
-|/usr/lib/python$(PYTHON_VERSION)/getopt.py
-|/usr/lib/python$(PYTHON_VERSION)/glob.py
-|/usr/lib/python$(PYTHON_VERSION)/hashlib.py
-|/usr/lib/python$(PYTHON_VERSION)/inspect.py
-|/usr/lib/python$(PYTHON_VERSION)/lib-dynload/array.$(PYTHON_LIBABI).so
-|/usr/lib/python$(PYTHON_VERSION)/lib-dynload/binascii.$(PYTHON_LIBABI).so
-|/usr/lib/python$(PYTHON_VERSION)/lib-dynload/_curses.$(PYTHON_LIBABI).so
-|/usr/lib/python$(PYTHON_VERSION)/lib-dynload/_curses_panel.$(PYTHON_LIBABI).so
-|/usr/lib/python$(PYTHON_VERSION)/lib-dynload/fcntl.$(PYTHON_LIBABI).so
-|/usr/lib/python$(PYTHON_VERSION)/lib-dynload/grp.$(PYTHON_LIBABI).so
-|/usr/lib/python$(PYTHON_VERSION)/lib-dynload/math.$(PYTHON_LIBABI).so
-|/usr/lib/python$(PYTHON_VERSION)/lib-dynload/_md5.$(PYTHON_LIBABI).so
-|/usr/lib/python$(PYTHON_VERSION)/lib-dynload/_random.$(PYTHON_LIBABI).so
-|/usr/lib/python$(PYTHON_VERSION)/lib-dynload/readline.$(PYTHON_LIBABI).so
-|/usr/lib/python$(PYTHON_VERSION)/lib-dynload/select.$(PYTHON_LIBABI).so
-|/usr/lib/python$(PYTHON_VERSION)/lib-dynload/_sha1.$(PYTHON_LIBABI).so
-|/usr/lib/python$(PYTHON_VERSION)/lib-dynload/_sha256.$(PYTHON_LIBABI).so
-|/usr/lib/python$(PYTHON_VERSION)/lib-dynload/_sha512.$(PYTHON_LIBABI).so
-|/usr/lib/python$(PYTHON_VERSION)/lib-dynload/_socket.$(PYTHON_LIBABI).so
-|/usr/lib/python$(PYTHON_VERSION)/lib-dynload/_struct.$(PYTHON_LIBABI).so
-|/usr/lib/python$(PYTHON_VERSION)/lib-dynload/syslog.$(PYTHON_LIBABI).so
-|/usr/lib/python$(PYTHON_VERSION)/lib-dynload/time.$(PYTHON_LIBABI).so
-|/usr/lib/python$(PYTHON_VERSION)/lib-dynload/unicodedata.$(PYTHON_LIBABI).so
-|/usr/lib/python$(PYTHON_VERSION)/linecache.py
-|/usr/lib/python$(PYTHON_VERSION)/opcode.py
-|/usr/lib/python$(PYTHON_VERSION)/optparse.py
-|/usr/lib/python$(PYTHON_VERSION)/os.py
-|/usr/lib/python$(PYTHON_VERSION)/pickle.py
-|/usr/lib/python$(PYTHON_VERSION)/pkgutil.py
-|/usr/lib/python$(PYTHON_VERSION)/posixpath.py
-|/usr/lib/python$(PYTHON_VERSION)/py_compile.py
-|/usr/lib/python$(PYTHON_VERSION)/random.py
-|/usr/lib/python$(PYTHON_VERSION)/reprlib.py
-|/usr/lib/python$(PYTHON_VERSION)/re.py
-|/usr/lib/python$(PYTHON_VERSION)/site.py
-|/usr/lib/python$(PYTHON_VERSION)/socket.py
-|/usr/lib/python$(PYTHON_VERSION)/sre_compile.py
-|/usr/lib/python$(PYTHON_VERSION)/sre_constants.py
-|/usr/lib/python$(PYTHON_VERSION)/sre_parse.py
-|/usr/lib/python$(PYTHON_VERSION)/stat.py
-|/usr/lib/python$(PYTHON_VERSION)/stringprep.py
-|/usr/lib/python$(PYTHON_VERSION)/string.py
-|/usr/lib/python$(PYTHON_VERSION)/struct.py
-|/usr/lib/python$(PYTHON_VERSION)/subprocess.py
-|/usr/lib/python$(PYTHON_VERSION)/tempfile.py
-|/usr/lib/python$(PYTHON_VERSION)/textwrap.py
-|/usr/lib/python$(PYTHON_VERSION)/tokenize.py
-|/usr/lib/python$(PYTHON_VERSION)/token.py
-|/usr/lib/python$(PYTHON_VERSION)/traceback.py
-|/usr/lib/python$(PYTHON_VERSION)/types.py
-|/usr/lib/python$(PYTHON_VERSION)/warnings.py
-|/usr/lib/python$(PYTHON_VERSION)/weakref.py
-|/usr/lib/python$(PYTHON_VERSION)/_weakrefset.py
-|/usr/lib/python$(PYTHON_VERSION)/sysconfig.py
-|/usr/lib/python$(PYTHON_VERSION)/_sysconfigdata.py
-|/usr/lib/python$(PYTHON_VERSION)/functools.py
-|/usr/lib/python$(PYTHON_VERSION)/collections
-|/usr/lib/python$(PYTHON_VERSION)/keyword.py
-|/usr/lib/python$(PYTHON_VERSION)/heapq.py
-|/usr/lib/python$(PYTHON_VERSION)/lib-dynload/_heapq.$(PYTHON_LIBABI).so
-|/usr/lib/python$(PYTHON_VERSION)/bisect.py
-|/usr/lib/python$(PYTHON_VERSION)/lib-dynload/_bisect.$(PYTHON_LIBABI).so
-|/usr/lib/python$(PYTHON_VERSION)/io.py
-|/usr/lib/python$(PYTHON_VERSION)/_compat_pickle.py
-|/usr/lib/python$(PYTHON_VERSION)/lib-dynload/_posixsubprocess.$(PYTHON_LIBABI).so
-|/usr/lib/python$(PYTHON_VERSION)/gzip.py
-|/usr/lib/python$(PYTHON_VERSION)/shutil.py
-|/usr/lib/python$(PYTHON_VERSION)/tarfile.py
-|/usr/lib/python$(PYTHON_VERSION)/lib-dynload/termios.$(PYTHON_LIBABI).so
-|/usr/lib/python$(PYTHON_VERSION)/ssl.py
-|/usr/lib/python$(PYTHON_VERSION)/turtle.py
-|/usr/lib/python$(PYTHON_VERSION)/turtledemo
-|/usr/lib/python$(PYTHON_VERSION)/base64.py
-|/usr/lib/python$(PYTHON_VERSION)/cgitb.py
-|/usr/lib/python$(PYTHON_VERSION)/curses
-|/usr/lib/python$(PYTHON_VERSION)/unittest/test
-|/usr/lib/python$(PYTHON_VERSION)/lib-dynload/_hashlib.$(PYTHON_LIBABI).so
-|/usr/lib/python$(PYTHON_VERSION)/lzma.py
-|/usr/lib/python$(PYTHON_VERSION)/lib-dynload/_lzma.$(PYTHON_LIBABI).so
-|/usr/lib/python$(PYTHON_VERSION)/tkinter
-|/usr/lib/python$(PYTHON_VERSION)/ctypes
-|/usr/lib/python$(PYTHON_VERSION)/lib-dynload/_ctypes.$(PYTHON_LIBABI).so
-|/usr/lib/python$(PYTHON_VERSION)/lib-dynload/_ctypes_test.$(PYTHON_LIBABI).so
-|/usr/lib/python$(PYTHON_VERSION)/_collections_abc.py
-|/usr/lib/python$(PYTHON_VERSION)/_sitebuiltins.py
-|/usr/lib/python$(PYTHON_VERSION)/ast.py
-|/usr/lib/python$(PYTHON_VERSION)/contextlib.py
-|/usr/lib/python$(PYTHON_VERSION)/enum.py
-|/usr/lib/python$(PYTHON_VERSION)/operator.py
-|/usr/lib/python$(PYTHON_VERSION)/selectors.py
-|/usr/lib/python$(PYTHON_VERSION)/plistlib.py
-|/usr/lib/python$(PYTHON_VERSION)/threading.py
-|/usr/lib/libpython$(PYTHON_VERSION)*
endef

define PyPackage/python3-mini/filespec
+|/usr/bin/python$(PYTHON_BINABI)
+|/usr/lib/python$(PYTHON_VERSION)/__future__.py
+|/usr/lib/python$(PYTHON_VERSION)/abc.py
+|/usr/lib/python$(PYTHON_VERSION)/codecs.py
+|/usr/lib/python$(PYTHON_VERSION)/compileall.py
+|/usr/lib/python$(PYTHON_VERSION)/imp.py
+|/usr/lib/python$(PYTHON_VERSION)/importlib
+|/usr/lib/python$(PYTHON_VERSION)/configparser.py
+|/usr/lib/python$(PYTHON_VERSION)/copy.py
+|/usr/lib/python$(PYTHON_VERSION)/copyreg.py
+|/usr/lib/python$(PYTHON_VERSION)/dis.py
+|/usr/lib/python$(PYTHON_VERSION)/encodings
+|/usr/lib/python$(PYTHON_VERSION)/fnmatch.py
+|/usr/lib/python$(PYTHON_VERSION)/genericpath.py
+|/usr/lib/python$(PYTHON_VERSION)/getopt.py
+|/usr/lib/python$(PYTHON_VERSION)/glob.py
+|/usr/lib/python$(PYTHON_VERSION)/hashlib.py
+|/usr/lib/python$(PYTHON_VERSION)/inspect.py
+|/usr/lib/python$(PYTHON_VERSION)/lib-dynload/array.$(PYTHON_LIBABI).so
+|/usr/lib/python$(PYTHON_VERSION)/lib-dynload/binascii.$(PYTHON_LIBABI).so
+|/usr/lib/python$(PYTHON_VERSION)/lib-dynload/fcntl.$(PYTHON_LIBABI).so
+|/usr/lib/python$(PYTHON_VERSION)/lib-dynload/grp.$(PYTHON_LIBABI).so
+|/usr/lib/python$(PYTHON_VERSION)/lib-dynload/math.$(PYTHON_LIBABI).so
+|/usr/lib/python$(PYTHON_VERSION)/lib-dynload/_md5.$(PYTHON_LIBABI).so
+|/usr/lib/python$(PYTHON_VERSION)/lib-dynload/_random.$(PYTHON_LIBABI).so
+|/usr/lib/python$(PYTHON_VERSION)/lib-dynload/select.$(PYTHON_LIBABI).so
+|/usr/lib/python$(PYTHON_VERSION)/lib-dynload/_sha1.$(PYTHON_LIBABI).so
+|/usr/lib/python$(PYTHON_VERSION)/lib-dynload/_sha256.$(PYTHON_LIBABI).so
+|/usr/lib/python$(PYTHON_VERSION)/lib-dynload/_sha512.$(PYTHON_LIBABI).so
+|/usr/lib/python$(PYTHON_VERSION)/lib-dynload/_socket.$(PYTHON_LIBABI).so
+|/usr/lib/python$(PYTHON_VERSION)/lib-dynload/_struct.$(PYTHON_LIBABI).so
+|/usr/lib/python$(PYTHON_VERSION)/lib-dynload/syslog.$(PYTHON_LIBABI).so
+|/usr/lib/python$(PYTHON_VERSION)/lib-dynload/time.$(PYTHON_LIBABI).so
+|/usr/lib/python$(PYTHON_VERSION)/lib-dynload/unicodedata.$(PYTHON_LIBABI).so
+|/usr/lib/python$(PYTHON_VERSION)/linecache.py
+|/usr/lib/python$(PYTHON_VERSION)/opcode.py
+|/usr/lib/python$(PYTHON_VERSION)/optparse.py
+|/usr/lib/python$(PYTHON_VERSION)/os.py
+|/usr/lib/python$(PYTHON_VERSION)/pickle.py
+|/usr/lib/python$(PYTHON_VERSION)/pkgutil.py
+|/usr/lib/python$(PYTHON_VERSION)/posixpath.py
+|/usr/lib/python$(PYTHON_VERSION)/py_compile.py
+|/usr/lib/python$(PYTHON_VERSION)/random.py
+|/usr/lib/python$(PYTHON_VERSION)/reprlib.py
+|/usr/lib/python$(PYTHON_VERSION)/re.py
+|/usr/lib/python$(PYTHON_VERSION)/site.py
+|/usr/lib/python$(PYTHON_VERSION)/socket.py
+|/usr/lib/python$(PYTHON_VERSION)/sre_compile.py
+|/usr/lib/python$(PYTHON_VERSION)/sre_constants.py
+|/usr/lib/python$(PYTHON_VERSION)/sre_parse.py
+|/usr/lib/python$(PYTHON_VERSION)/stat.py
+|/usr/lib/python$(PYTHON_VERSION)/stringprep.py
+|/usr/lib/python$(PYTHON_VERSION)/string.py
+|/usr/lib/python$(PYTHON_VERSION)/struct.py
+|/usr/lib/python$(PYTHON_VERSION)/subprocess.py
+|/usr/lib/python$(PYTHON_VERSION)/tempfile.py
+|/usr/lib/python$(PYTHON_VERSION)/textwrap.py
+|/usr/lib/python$(PYTHON_VERSION)/tokenize.py
+|/usr/lib/python$(PYTHON_VERSION)/token.py
+|/usr/lib/python$(PYTHON_VERSION)/traceback.py
+|/usr/lib/python$(PYTHON_VERSION)/types.py
+|/usr/lib/python$(PYTHON_VERSION)/warnings.py
+|/usr/lib/python$(PYTHON_VERSION)/weakref.py
+|/usr/lib/python$(PYTHON_VERSION)/_weakrefset.py
+|/usr/lib/python$(PYTHON_VERSION)/config-$(PYTHON_BINABI)/Makefile
+|/usr/lib/python$(PYTHON_VERSION)/sysconfig.py
+|/usr/lib/python$(PYTHON_VERSION)/_sysconfigdata.py
+|/usr/lib/python$(PYTHON_VERSION)/functools.py
+|/usr/lib/python$(PYTHON_VERSION)/collections
+|/usr/lib/python$(PYTHON_VERSION)/keyword.py
+|/usr/lib/python$(PYTHON_VERSION)/heapq.py
+|/usr/lib/python$(PYTHON_VERSION)/lib-dynload/_heapq.$(PYTHON_LIBABI).so
+|/usr/lib/python$(PYTHON_VERSION)/bisect.py
+|/usr/lib/python$(PYTHON_VERSION)/lib-dynload/_bisect.$(PYTHON_LIBABI).so
+|/usr/include/python$(PYTHON_BINABI)/pyconfig.h
+|/usr/lib/python$(PYTHON_VERSION)/io.py
+|/usr/lib/python$(PYTHON_VERSION)/_compat_pickle.py
+|/usr/lib/python$(PYTHON_VERSION)/lib-dynload/_posixsubprocess.$(PYTHON_LIBABI).so
+|/usr/lib/python$(PYTHON_VERSION)/base64.py
+|/usr/lib/python$(PYTHON_VERSION)/gzip.py
+|/usr/lib/python$(PYTHON_VERSION)/shutil.py
+|/usr/lib/python$(PYTHON_VERSION)/tarfile.py
+|/usr/lib/python$(PYTHON_VERSION)/lib-dynload/termios.$(PYTHON_LIBABI).so
+|/usr/lib/python$(PYTHON_VERSION)/_collections_abc.py
+|/usr/lib/python$(PYTHON_VERSION)/_sitebuiltins.py
+|/usr/lib/python$(PYTHON_VERSION)/ast.py
+|/usr/lib/python$(PYTHON_VERSION)/contextlib.py
+|/usr/lib/python$(PYTHON_VERSION)/enum.py
+|/usr/lib/python$(PYTHON_VERSION)/operator.py
+|/usr/lib/python$(PYTHON_VERSION)/selectors.py
+|/usr/lib/python$(PYTHON_VERSION)/threading.py
+|/usr/lib/libpython$(PYTHON_VERSION)*
endef

# PEP 394
define PyPackage/python3-mini/install
	ln -sf python$(PYTHON_BINABI) $(1)/usr/bin/python3
endef

define PyPackage/python3-doc/filespec
+|/usr/lib/python$(PYTHON_VERSION)/pydoc_data
+|/usr/lib/python$(PYTHON_VERSION)/pydoc.py
+|/usr/lib/python$(PYTHON_VERSION)/cgitb.py
endef

define PyPackage/python3-bzip2/filespec
+|/usr/lib/python$(PYTHON_VERSION)/lib-dynload/_bz2.$(PYTHON_LIBABI).so
+|/usr/lib/python$(PYTHON_VERSION)/bz2.py
endef

define PyPackage/python3-expat/filespec
+|/usr/lib/python$(PYTHON_VERSION)/lib-dynload/pyexpat.$(PYTHON_LIBABI).so
+|/usr/lib/python$(PYTHON_VERSION)/plistlib.py
endef

define PyPackage/python3-ssl/filespec
+|/usr/lib/python$(PYTHON_VERSION)/lib-dynload/_ssl.$(PYTHON_LIBABI).so
+|/usr/lib/python$(PYTHON_VERSION)/ssl.py
+|/usr/lib/python$(PYTHON_VERSION)/lib-dynload/_hashlib.$(PYTHON_LIBABI).so
endef

define PyPackage/python3-sqlite3/filespec
+|/usr/lib/python$(PYTHON_VERSION)/sqlite3
+|/usr/lib/python$(PYTHON_VERSION)/lib-dynload/_sqlite3.$(PYTHON_LIBABI).so
-|/usr/lib/python$(PYTHON_VERSION)/sqlite3/test
endef

define PyPackage/python3-gdbm/filespec
+|/usr/lib/python$(PYTHON_VERSION)/dbm/gnu.py
+|/usr/lib/python$(PYTHON_VERSION)/lib-dynload/_gdbm.$(PYTHON_LIBABI).so
endef

define PyPackage/python3-ndbm/filespec
+|/usr/lib/python$(PYTHON_VERSION)/dbm/ndbm.py
+|/usr/lib/python$(PYTHON_VERSION)/lib-dynload/_dbm.$(PYTHON_LIBABI).so
endef

define PyPackage/python3-readline/filespec
+|/usr/lib/python$(PYTHON_VERSION)/lib-dynload/readline.$(PYTHON_LIBABI).so
endef

define PyPackage/python3-ncurses/filespec
+|/usr/lib/python$(PYTHON_VERSION)/lib-dynload/_curses.$(PYTHON_LIBABI).so
+|/usr/lib/python$(PYTHON_VERSION)/lib-dynload/_curses_panel.$(PYTHON_LIBABI).so
+|/usr/lib/python$(PYTHON_VERSION)/curses
endef

define PyPackage/python3-ctypes/filespec
+|/usr/lib/python$(PYTHON_VERSION)/lib-dynload/_ctypes.$(PYTHON_LIBABI).so
+|/usr/lib/python$(PYTHON_VERSION)/ctypes
-|/usr/lib/python$(PYTHON_VERSION)/ctypes/test
endef

define PyPackage/python3-2to3/filespec
+|/usr/lib/python$(PYTHON_VERSION)/lib2to3
-|/usr/lib/python$(PYTHON_VERSION)/lib2to3/tests
endef

define PyPackage/python3-testsuite/filespec
+|/usr/lib/python$(PYTHON_VERSION)/test
+|/usr/lib/python$(PYTHON_VERSION)/ctypes/test
+|/usr/lib/python$(PYTHON_VERSION)/distutils/tests
+|/usr/lib/python$(PYTHON_VERSION)/lib2to3/tests
+|/usr/lib/python$(PYTHON_VERSION)/sqlite3/test
+|/usr/lib/python$(PYTHON_VERSION)/unittest/test
+|/usr/lib/python$(PYTHON_VERSION)/lib-dynload/_ctypes_test.$(PYTHON_LIBABI).so
+|/usr/lib/python$(PYTHON_VERSION)/lib-dynload/_testcapi.$(PYTHON_LIBABI).so
endef

#define PyPackage/python3-lzma/filespec
#+|/usr/lib/python$(PYTHON_VERSION)/lzma.py
#+|/usr/lib/python$(PYTHON_VERSION)/lib-dynload/_lzma.$(PYTHON_LIBABI).so
#endef

define Host/Configure
	-$(MAKE) -C $(HOST_BUILD_DIR) distclean
	(cd $(HOST_BUILD_DIR); autoreconf --force --install || exit 0)
	(cd $(HOST_BUILD_DIR); \
		rm -rf config.cache; \
		CONFIG_SITE= \
		OPT="$(HOST_CFLAGS)" \
		./configure --enable-shared --without-cxx-main --with-threads --without-ensurepip --prefix=$(STAGING_DIR_HOST); \
	)
endef

define Host/Compile
	+$(MAKE) $(HOST_JOBS) -C $(HOST_BUILD_DIR) \
		python Parser/pgen
	+$(MAKE) $(HOST_JOBS) -C $(HOST_BUILD_DIR) \
		HOSTPYTHON=$(HOST_BUILD_DIR)/python \
		sharedmods
endef

define Host/Install
	$(INSTALL_DIR) $(STAGING_DIR_HOST)/bin/
	$(MAKE) -C $(HOST_BUILD_DIR) \
		HOSTPYTHON=$(HOST_BUILD_DIR)/python \
		install
	$(INSTALL_BIN) $(HOST_BUILD_DIR)/Parser/pgen $(STAGING_DIR_HOST)/bin/pgen3
endef


$(eval $(call HostBuild))

$(eval $(call PyPackage,python3))
$(eval $(call PyPackage,python3-mini))
$(eval $(call PyPackage,python3-doc))
$(eval $(call PyPackage,python3-bzip2))
$(eval $(call PyPackage,python3-expat))
$(eval $(call PyPackage,python3-ssl))
$(eval $(call PyPackage,python3-sqlite3))
$(eval $(call PyPackage,python3-gdbm))
$(eval $(call PyPackage,python3-ndbm))
$(eval $(call PyPackage,python3-readline))
$(eval $(call PyPackage,python3-ncurses))
$(eval $(call PyPackage,python3-ctypes))
$(eval $(call PyPackage,python3-2to3))
$(eval $(call PyPackage,python3-testsuite))
#$(eval $(call PyPackage,python3-lzma))

$(eval $(call BuildPackage,python3))
$(eval $(call BuildPackage,python3-mini))
$(eval $(call BuildPackage,python3-doc))
$(eval $(call BuildPackage,python3-bzip2))
$(eval $(call BuildPackage,python3-expat))
$(eval $(call BuildPackage,python3-ssl))
$(eval $(call BuildPackage,python3-sqlite3))
$(eval $(call BuildPackage,python3-gdbm))
$(eval $(call BuildPackage,python3-ndbm))
$(eval $(call BuildPackage,python3-readline))
$(eval $(call BuildPackage,python3-ncurses))
$(eval $(call BuildPackage,python3-ctypes))
$(eval $(call BuildPackage,python3-2to3))
$(eval $(call BuildPackage,python3-testsuite))
#$(eval $(call BuildPackage,python3-lzma))

