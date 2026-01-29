#
# Copyright (C) 2025 OpenWrt.org
#
# This is free software, licensed under the MIT License
# See /LICENSE for more information.

include $(TOPDIR)/rules.mk

PKG_NAME:=tsshd
PKG_VERSION:=0.1.6
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/trzsz/tsshd.git
PKG_SOURCE_VERSION:=v$(PKG_VERSION)
PKG_MIRROR_HASH:=a303c14bd5a41303d56254cfa97b93ca5025c0138a8ceb9d0d777eb715b0c1bd

PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=OpenWrt

PKG_BUILD_DEPENDS:=golang/host
PKG_BUILD_PARALLEL:=1
PKG_BUILD_FLAGS:=no-mips16

GO_PKG:=github.com/trzsz/tsshd
GO_PKG_BUILD_PKG:=$(GO_PKG)/cmd/tsshd

include $(INCLUDE_DIR)/package.mk
include ../../../../feeds/packages/lang/golang/golang-package.mk

define Package/tsshd
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=SSH
  TITLE:=trzsz ssh server (supports connection migration)
  URL:=https://github.com/trzsz/tsshd
  DEPENDS:=$(GO_ARCH_DEPENDS)
endef

define Package/tsshd/description
 tsshd is an ssh server that supports connection migration for roaming.
 Works with tssh (trzsz-ssh) client to provide intermittent connectivity
 and roaming support.
endef

define Package/tsshd/conffiles
/etc/config/tsshd
endef

define Package/tsshd/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(GO_PKG_BUILD_BIN_DIR)/tsshd $(1)/usr/bin/tsshd
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/tsshd.config $(1)/etc/config/tsshd
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/tsshd.init $(1)/etc/init.d/tsshd
endef

$(eval $(call GoBinPackage,tsshd))
$(eval $(call BuildPackage,tsshd))
