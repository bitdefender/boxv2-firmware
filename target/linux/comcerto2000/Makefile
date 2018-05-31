# 
# Copyright (C) 2008 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk

TARGET_ARCH=arm

ARCH:=$(TARGET_ARCH)
BOARD:=comcerto2000
BOARDNAME:=Comcerto-2000
FEATURES:=jffs2 pci usb
SUBTARGETS=hgw nas hgw_nas gpp

define Target/Description
	Build firmware images for Mindspeed ComcertoTM 2000 SoC
endef

ifeq ($(CONFIG_LINUX_3_2),y)
LINUX_VERSION=3.2.54
endif

ifeq ($(CONFIG_LINUX_3_19),y)
LINUX_VERSION=3.19.3
endif

ifeq ($(LINUX_VERSION),)
 LINUX_VERSION=3.2.54
endif

include $(INCLUDE_DIR)/target.mk

LINUX_PROFILE_CONFIG:=$(CURDIR)/$(SUBTARGET)/configs/$(PROFILE)

ifeq ($(CONFIG_DEV_KERNEL),y)
ifeq ($(CONFIG_DEV_KERNEL_GITBRANCH), "")
define Kernel/Prepare
	mkdir -p $(KERNEL_BUILD_DIR)
	pushd "$(KERNEL_BUILD_DIR)" && \
	git clone ssh://$(CONFIG_ACTIVEDEV_GITUSERNAME)@$(CONFIG_ACTIVEDEV_GITROOTPATH)/$(CONFIG_DEV_KERNEL_MODULENAME) linux-$(LINUX_VERSION) && \
	popd
endef
else
define Kernel/Prepare
	mkdir -p $(KERNEL_BUILD_DIR)
	pushd "$(KERNEL_BUILD_DIR)" && \
	git clone ssh://$(CONFIG_ACTIVEDEV_GITUSERNAME)@$(CONFIG_ACTIVEDEV_GITROOTPATH)/$(CONFIG_DEV_KERNEL_MODULENAME) linux-$(LINUX_VERSION) &&  \
	pushd "linux-$(LINUX_VERSION)" && \
	if [ -n "$$$$(git tag | grep -w $(CONFIG_DEV_KERNEL_GITBRANCH))" ]; then \
		git checkout -b $(CONFIG_DEV_KERNEL_GITBRANCH) $(CONFIG_DEV_KERNEL_GITBRANCH); \
	elif [ -n "$$$$(git branch -a | grep -w remotes\/origin\/$(CONFIG_DEV_KERNEL_GITBRANCH))" ]; then \
		git checkout -b $(CONFIG_DEV_KERNEL_GITBRANCH) origin/$(CONFIG_DEV_KERNEL_GITBRANCH); \
	else \
		echo "Invalid tag or branch name. \"$(CONFIG_DEV_KERNEL_GITBRANCH)\""; \
		exit 1; \
	fi; \
	popd; \
	popd
endef
endif
endif

define Kernel/Configure
	$(call Kernel/Configure/Default)
ifeq ($(CONFIG_COMCERTO_PAGE_SIZE_64K),y)
	sed -i 's/# CONFIG_COMCERTO_64K_PAGES is not set/CONFIG_COMCERTO_64K_PAGES=y/' $(LINUX_DIR)/.config
endif

#
# do not reserve DMA memory in kernel if DECT package is not compiled
#
ifneq ($(CONFIG_PACKAGE_dspg-dect-css),y)
	sed -i 's/CONFIG_DSPG_DECT_CSS=y/# CONFIG_DSPG_DECT_CSS is not set/' $(LINUX_DIR)/.config
endif
endef

KERNELNAME:="uImage"
$(eval $(call BuildTarget))
