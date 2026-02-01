include $(TOPDIR)/rules.mk

PKG_NAME:=ffnh-support-enable
PKG_VERSION:=1.0
PKG_RELEASE:=1

include $(TOPDIR)/../package/gluon.mk

define Package/ffnh-support-enable
  TITLE:=Support-Funktion für Freifunk Nordhessen
  DEPENDS:=+gluon-config-mode-core
  MAINTAINER:=Freifunk Nordhessen e.V. <m.hertel@freifunk-nordhessen.de>
endef

$(eval $(call BuildPackage,ffnh-support-enable))
