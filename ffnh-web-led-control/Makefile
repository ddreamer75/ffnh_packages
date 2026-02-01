
include $(TOPDIR)/rules.mk

PKG_NAME:=ffnh-web-led-control
PKG_VERSION:=1.0.0
PKG_RELEASE:=1

PKG_MAINTAINER:=Freifunk Nordhessen e.V. <m.hertel@freifunk-nordhessen.de>

include $(TOPDIR)/../package/gluon.mk

define Package/$(PKG_NAME)
  TITLE:=FFNH LED frontend (Admin GUI)
  DEPENDS:=+gluon-web-admin +ffnh-led-control
endef

$(eval $(call BuildPackageGluon,$(PKG_NAME)))
