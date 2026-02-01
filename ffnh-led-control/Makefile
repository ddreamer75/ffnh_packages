include $(TOPDIR)/rules.mk

PKG_NAME:=ffnh-led-control
PKG_VERSION:=1.0
PKG_RELEASE:=1

include $(TOPDIR)/../package/gluon.mk

define Package/ffnh-led-control
  SECTION:=gluon
  CATEGORY:=Gluon
  TITLE:=Freifunk Nordhessen LED Control Backend
  MAINTAINER:=Freifunk Nordhessen e.V. <m.hertel@freifunk-nordhessen.de>
  # DEPENDS:=+busybox +uci +jshn +jsonfilter
endef

define Package/ffnh-led-control/description
Backend for per-device LED control via Gluon config-mode.
Provides JSON capabilities detection and applies LED settings.
endef

define Build/Compile
endef

define Package/ffnh-led-control/install
	$(CP) ./files/* $(1)/
endef

$(eval $(call BuildPackage,ffnh-led-control))
