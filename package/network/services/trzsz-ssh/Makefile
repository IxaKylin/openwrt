#
# Copyright (C) 2025 OpenWrt.org
#
# This is free software, licensed under the MIT License
# See /LICENSE for more information.

include $(TOPDIR)/rules.mk

PKG_NAME:=trzsz-ssh
PKG_VERSION:=0.1.24
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/trzsz/trzsz-ssh.git
PKG_SOURCE_VERSION:=v$(PKG_VERSION)
PKG_MIRROR_HASH:=8c7ef4ace4c7aed564f447f3f91142367f782eef87b58a95f587480ca1ae08ba

PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=OpenWrt

PKG_BUILD_DEPENDS:=golang/host
PKG_BUILD_PARALLEL:=1
PKG_BUILD_FLAGS:=no-mips16

GO_PKG:=github.com/trzsz/trzsz-ssh
GO_PKG_BUILD_PKG:=$(GO_PKG)/cmd/tssh

include $(INCLUDE_DIR)/package.mk
include ../../../../feeds/packages/lang/golang/golang-package.mk

define Package/trzsz-ssh
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=SSH
  TITLE:=trzsz ssh client (supports connection migration)
  URL:=https://github.com/trzsz/trzsz-ssh
  DEPENDS:=$(GO_ARCH_DEPENDS)
endef

define Package/trzsz-ssh/description
 tssh is an ssh client designed as a drop-in replacement for the openssh
 client. It aims to provide complete compatibility with openssh, mirroring
 all its features, while also offering additional useful features.

 With tsshd, it supports intermittent connectivity, allows roaming, and
 can be used on high-latency links such as cellular data connections.
endef

define Package/trzsz-ssh/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(GO_PKG_BUILD_BIN_DIR)/tssh $(1)/usr/bin/tssh
endef

$(eval $(call GoBinPackage,trzsz-ssh))
$(eval $(call BuildPackage,trzsz-ssh))
