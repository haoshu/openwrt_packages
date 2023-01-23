#
# Copyright (c) 2010 Duo Security
# All rights reserved, all wrongs reversed.
#
# duo_unix is distributed under the terms of the GNU General Public
# License v2 with clarification and special exceptions.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=duo_unix
PKG_VERSION:=2.0.0
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/duosecurity/duo_unix.git
PKG_SOURCE_DATE:=2022-10-25
PKG_SOURCE_VERSION:=5852eef1946ede05b46d8fffdbfb990b68a73861
PKG_MIRROR_HASH:=cd36c1e2b7902e9462765c3b04bc5b7890e38141f4495ebe8f2804952aeced57

PKG_LICENSE:=GPL-2.0
PKG_LICENSE_FILES:=LICENSE

PKG_FIXUP:=autoreconf
PKG_MACRO_PATHS:=autotools
PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk

define Package/duo_unix/Default
	SECTION:=libs
	CATEGORY:=Libraries
	DEPENDS:=+libopenssl
	TITLE:=Duo Unix
	URL:=https://github.com/duosecurity/duo_unix
endef

define Package/duo_unix-pam
	$(call Package/duo_unix/Default)
	DEPENDS+= +libpam
	TITLE+= PAM module
endef

define Package/duo_unix-pam/description
pam_duo: Duo Unix PAM module.
endef

define Package/duo_unix-pam/conffiles
/etc/duo/pam_duo.conf
endef

define Package/duo_unix-login
	$(call Package/duo_unix/Default)
	TITLE+= login module
endef

define Package/duo_unix-login/description
login_duo: Duo Unix login module.
endef

define Package/duo_unix-login/conffiles
/etc/duo/login_duo.conf
endef

define Build/Prepare
	$(call Build/Prepare/Default)
	# Workaround for X509_TEA_set_state test in cross compile environment
	# See - https://github.com/duosecurity/duo_unix/issues/170
	sed --in-place=.default -e 's/AC_MSG_RESULT(\[no\])/],[AC_MSG_RESULT([no])/g' $(PKG_BUILD_DIR)/autotools/ax_check_x509.m4

	# See - https://github.com/duosecurity/duo_unix/issues/240
	# Patch to make Duo FAIL_SECURE by nature
	sed --in-place=.default -e '1,/DUO_FAIL_SAFE/s/DUO_FAIL_SAFE/DUO_FAIL_SECURE/' $(PKG_BUILD_DIR)/lib/util.c
	# Patch to skip pam_duo when the user is not a member of the groups specified in conf file
	sed --in-place=.default -e 's/\(bypassed Duo.*\)/\1\n        close_config(\&cfg);\n        return (PAM_IGNORE);/' $(PKG_BUILD_DIR)/pam_duo/pam_duo.c 
endef

CONFIGURE_VARS += \
	CROSS_COMPILE="yes"

CONFIGURE_ARGS += \
	--prefix='' \
	--sysconfdir='/etc/duo' \
	--with-pam=/usr/lib/security \
	--with-privsep-user=nobody

define Package/duo_unix-pam/install
	$(INSTALL_DIR) $(1)/etc/duo
	$(INSTALL_CONF) $(PKG_BUILD_DIR)/pam_duo/pam_duo.conf $(1)/etc/duo/

	$(INSTALL_DIR) $(1)/usr/lib/security/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/pam_duo/.libs/pam_duo.so $(1)/usr/lib/security/
endef

define Package/duo_unix-login/install
	$(INSTALL_DIR) $(1)/etc/duo
	$(INSTALL_CONF) $(PKG_BUILD_DIR)/login_duo/login_duo.conf $(1)/etc/duo/

	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/login_duo/login_duo $(1)/usr/sbin/
endef

$(eval $(call BuildPackage,duo_unix-pam))
$(eval $(call BuildPackage,duo_unix-login))
