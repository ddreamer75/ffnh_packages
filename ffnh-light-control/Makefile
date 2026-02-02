include $(TOPDIR)/rules.mk

PKG_NAME:=ffnh-light-control
PKG_VERSION:=1.0.0
PKG_RELEASE:=1

include $(TOPDIR)/../package/gluon.mk

define Package/$(PKG_NAME)
  SECTION:=gluon
  CATEGORY:=Gluon
  TITLE:=FFNH Light Control (admin)
  DEPENDS:=+gluon-web-admin +gluon-core +lua +libuci-lua
  MAINTAINER:=Freifunk Nordhessen e.V. <m.hertel@freifunk-nordhessen.de>
endef

define Package/$(PKG_NAME)/description
Provides an admin page and backend to control the device status LED (color and permanent on/off).
endef

define Build/Prepare
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(CP) ./files/* $(1)/
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
