# 
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=fci
PKG_VERSION:=9.00
PKG_RELEASE:=1


PKG_BUILD_DIR:=$(KERNEL_BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE)
PKG_INSTALL_DIR:=$(PKG_BUILD_DIR)/ipkg-install


PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE).tar.gz
PKG_CAT:=zcat

include $(INCLUDE_DIR)/package.mk

define KernelPackage/fci
  CATEGORY:=Freescale Packages
  DEFAULT:=n
  DEPENDS:=+fci +TARGET_ls1043a:kmod-cdx
  TITLE:=Fast Control Interface kernel
  URL:=http://www.freescale.com/
  MAINTAINER:=Freescale Semiconductors
  FILES:= $(PKG_BUILD_DIR)/fci.$(LINUX_KMOD_SUFFIX)
endef

define Package/fci
  CATEGORY:=Freescale Packages
  DEFAULT:=n
  TITLE:=Fast Control Interface user
  URL:=http://www.freescale.com/
  MAINTAINER:=Freescale Semiconductors
endef

define Package/fci/description
 kernel module managing communication between user space and kernel space.
endef

#If Development, we should downlaod the version from our CVS instead of doing the generic process
ifeq ($(CONFIG_DEV_FCI), y)

ifeq ($(CONFIG_DEV_FCI_GITBRANCH), "")
define Build/Prepare
	pushd "$(KERNEL_BUILD_DIR)" && \
	git clone ssh://$(CONFIG_ACTIVEDEV_GITUSERNAME)@$(CONFIG_ACTIVEDEV_GITROOTPATH)/$(CONFIG_DEV_FCI_GITTREE) $(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE) && \
	popd
	@if [ -d ./patches -a "$$$$(ls ./patches | wc -l)" -gt 0 ]; then \
		$(KPATCH) $(PKG_BUILD_DIR) ./patches; \
	fi
endef

else
define Build/Prepare
	pushd "$(KERNEL_BUILD_DIR)" && \
	git clone ssh://$(CONFIG_ACTIVEDEV_GITUSERNAME)@$(CONFIG_ACTIVEDEV_GITROOTPATH)/$(CONFIG_DEV_FCI_GITTREE) $(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE) && \
	pushd "$(PKG_NAME)-$(PKG_VERSION).$(PKG_RELEASE)" && \
	if [ -n "$$$$(git tag | grep -w $(CONFIG_DEV_FCI_GITBRANCH))" ]; then \
		git checkout -b $(CONFIG_DEV_FCI_GITBRANCH) $(CONFIG_DEV_FCI_GITBRANCH); \
	elif [ -n "$$$$(git branch -a | grep -w remotes\/origin\/$(CONFIG_DEV_FCI_GITBRANCH))" ]; then \
		git checkout -b $(CONFIG_DEV_FCI_GITBRANCH) origin/$(CONFIG_DEV_FCI_GITBRANCH); \
	else \
		echo "Invalid tag or branch name. \"$(CONFIG_DEV_FCI_GITBRANCH)\""; \
		exit 1; \
	fi; \
	popd; \
	popd
	@if [ -d ./patches -a "$$$$(ls ./patches | wc -l)" -gt 0 ]; then \
		$(KPATCH) $(PKG_BUILD_DIR) ./patches ; \
	fi
endef

endif
endif

TARGET_BOARD_ARCH:=arm
ifeq ($(CONFIG_TARGET_ls1043a)$(CONFIG_TARGET_ls1012a),y)
	TARGET_BOARD_ARCH:=arm64
endif
ifeq ($(CONFIG_TARGET_comcerto2000),y)
	TARGET_BOARD_ARCH:=arm
endif

define Build/Configure
        (cd $(PKG_BUILD_DIR)/lib; rm -rf config.{cache,status} ; \
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
        );
endef

define Build/Compile
	$(call Build/Compile/Default, KERNEL_SOURCE="$(LINUX_DIR)" BOARD_ARCH="$(TARGET_BOARD_ARCH)")
	
	$(MAKE) -C $(PKG_BUILD_DIR)/lib \
		CCOPT="$(TARGET_CFLAGS)" \
		DESTDIR="$(PKG_INSTALL_DIR)" all install
endef

define Build/InstallDev
	install -d -m0755 $(STAGING_DIR)/usr/lib
	install -d -m0755 $(STAGING_DIR)/usr/include
	$(CP) $(PKG_BUILD_DIR)/lib/include/*.h $(STAGING_DIR)/usr/include/
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/* $(STAGING_DIR)/usr/lib/
endef

define Build/UninstallDev
	$(RM) $(STAGING_DIR)/usr/include/libfci.h
	$(RM) $(STAGING_DIR)/usr/lib/libfci.*
endef

define Package/fci/install
	$(CP) ./files/etc $(1)/

	install -d -m0755 $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libfci.so* $(1)/usr/lib/
endef

$(eval $(call KernelPackage,fci))
$(eval $(call BuildPackage,fci))
