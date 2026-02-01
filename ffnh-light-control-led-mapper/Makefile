
include $(TOPDIR)/rules.mk

PKG_NAME:=gluon-ffnh-light-control-led-mapper
PKG_VERSION:=1.0.0
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(GLUONDIR)/include/package.mk

define Package/$(PKG_NAME)
  SECTION:=gluon
  CATEGORY:=Gluon
  TITLE:=FFNH Light Control – LED Mapper (vendor/model)
  MAINTAINER:=Freifunk Nordhessen e.V. <m.hertel@freifunk-nordhessen.de>
endef

define Package/$(PKG_NAME)/description
Provides vendor/model LED mappings for ffnh-light-control (sysfs LED names and available colors).
endef

define Build/Prepare
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/share/ffnh-light-control/mapper
	$(CP) ./files/usr/share/ffnh-light-control/mapper/* $(1)/usr/share/ffnh-light-control/mapper/
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
