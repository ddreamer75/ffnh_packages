
include $(TOPDIR)/rules.mk

PKG_NAME:=ffnh-web-led-control
PKG_VERSION:=1.0.0
PKG_RELEASE:=1

PKG_MAINTAINER:=Freifunk Nordhessen e.V. <m.hertel@freifunk-nordhessen.de>
PKG_LICENSE:=GPL-2.0-or-later

include $(TOPDIR)/../package/gluon.mk

PKG_CONFIG_DEPENDS += $(GLUON_I18N_CONFIG)

define Package/$(PKG_NAME)
  TITLE:=FFNH LED frontend (Admin GUI)
  DEPENDS:=+gluon-web-admin +gluon-web-model +ffnh-led-control
endef

define Package/$(PKG_NAME)/description
Admin web page to configure status LED color, brightness, permanent on/off and timer; hides controls when not supported.
endef

define Build/Compile
	$(call GluonBuildI18N,$(PKG_NAME),i18n)
endef

define Package/$(PKG_NAME)/install
	$(call GluonInstallI18N,$(PKG_NAME),$(1))
endef

$(eval $(call BuildPackageGluon,$(PKG_NAME)))
