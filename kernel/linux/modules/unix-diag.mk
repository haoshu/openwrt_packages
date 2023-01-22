#
# Copyright (C) 2006-2011 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
NETWORK_SUPPORT_MENU:=Network Support

define KernelPackage/unix-diag
	SUBMENU:=$(NETWORK_SUPPORT_MENU)
	TITLE:=Unix domain socket monitoring interface
	URL:=https://man7.org/linux/man-pages/man7/sock_diag.7.html
	KCONFIG:=CONFIG_UNIX_DIAG
	FILES:=$(LINUX_DIR)/net/unix/unix_diag.ko
	AUTOLOAD:=$(call AutoProbe,unix_diag)
endef

define KernelPackage/unix-diag/description
Unix domain socket diag support
endef

$(eval $(call KernelPackage,unix-diag))
