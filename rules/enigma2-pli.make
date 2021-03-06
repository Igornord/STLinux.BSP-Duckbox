# -*-makefile-*-
#
# Copyright (C) 2003 by Robert Schwebel <r.schwebel@pengutronix.de>
#                       Pengutronix <info@pengutronix.de>, Germany
#               2009, 2010 by Marc Kleine-Budde <mkl@pengutronix.de>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_ENIGMA2_PLI) += enigma2-pli
PACKAGES-$(PTXCONF_ENIGMA2_PLI_DEV) += enigma2-pli-dev

#
# Paths and names
#
##### enigma2-pli-arp
ifdef PTXCONF_ENIGMA2_PLI_VERSION_MASTER
ENIGMA2_PLI_VERSION	:= testing
endif
ifdef PTXCONF_ENIGMA2_PLI_VERSION_LAST
ENIGMA2_PLI_VERSION	:= aa18b40b5234d59867c5998caa819b19e16e4079
endif
#####
ifdef PTXCONF_ENIGMA2_PLI_VERSION_201203171951
ENIGMA2_PLI_VERSION	:= 945aeb939308b3652b56bc6c577853369d54a537
endif
ifdef PTXCONF_ENIGMA2_PLI_VERSION_201205181526
ENIGMA2_PLI_VERSION	:= 839e96b79600aba73f743fd39628f32bc1628f4c
endif
ifdef PTXCONF_ENIGMA2_PLI_VERSION_201301282130
ENIGMA2_PLI_VERSION	:= ce3b90e73e88660bafe900f781d434dd6bd25f71
endif
ifdef PTXCONF_ENIGMA2_PLI_VERSION_201303022136
ENIGMA2_PLI_VERSION	:= 4361a969cde00cd37d6d17933f2621ea49b5a30a
endif


ENIGMA2_PLI		:= enigma2-pli-$(ENIGMA2_PLI_VERSION)
ifdef PTXCONF_ENIGMA2_PLI_ARP
ENIGMA2_PLI_URL	:= https://code.google.com/p/enigma2-cris-technic
ENIGMA2_PLI_SOURCE_GIT	:= $(SRCDIR)/enigma2-cris-technic
else
ENIGMA2_PLI_URL	:= git://git.code.sf.net/p/openpli/enigma2
ENIGMA2_PLI_URLOLD := git://openpli.git.sourceforge.net/gitroot/openpli/enigma2
ENIGMA2_PLI_SOURCE_GIT	:= $(SRCDIR)/enigma2-pli.git
endif
ENIGMA2_PLI_DIR	:= $(BUILDDIR)/$(ENIGMA2_PLI)
ENIGMA2_PLI_LICENSE	:= enigma2-pli

ENIGMA2_PLI_DEV_VERSION	:= $(ENIGMA2_PLI_VERSION)
ENIGMA2_PLI_DEV_PKGDIR	:= $(ENIGMA2_PLI_PKGDIR)

$(STATEDIR)/enigma2-pli.get:
	@$(call targetinfo)
	
		if [ -d $(ENIGMA2_PLI_SOURCE_GIT) ]; then \
			cd $(ENIGMA2_PLI_SOURCE_GIT); \
			git pull -u origin master 2>&1 > /dev/null; \
			git checkout $(ENIGMA2_PLI_VERSION) 2>&1 > /dev/null; \
			cd -; \
		else \
			git clone  $(ENIGMA2_PLI_URL) $(ENIGMA2_PLI_SOURCE_GIT) 2>&1 > /dev/null; \
		fi; 2>&1 > /dev/null
	
		if [ ! "$(ENIGMA2_PLI_VERSION)" == "HEAD" ]; then \
			cd $(ENIGMA2_PLI_SOURCE_GIT); \
			git checkout $(ENIGMA2_PLI_VERSION) 2>&1 > /dev/null; \
			cd -; \
		fi; 2>&1 > /dev/null
	
	@$(call touch)

PATH_PATCHES = $(subst :, ,$(PTXDIST_PATH_PATCHES))

$(STATEDIR)/enigma2-pli.extract:
	@$(call targetinfo)
	
	rm -rf $(ENIGMA2_PLI_DIR); \
	cp -a $(ENIGMA2_PLI_SOURCE_GIT) $(ENIGMA2_PLI_DIR); \
	rm -rf $(ENIGMA2_PLI_DIR)/.git;
	
	@$(call patchin, ENIGMA2_PLI)
ifdef !PTXCONF_ENIGMA2_PLI_ARP	
	cp $(word 1, $(PATH_PATCHES))/$(ENIGMA2_PLI)/valis_enigma.ttf $(ENIGMA2_PLI_DIR)/data/fonts/
	cp $(word 1, $(PATH_PATCHES))/$(ENIGMA2_PLI)/valis_lcd.ttf $(ENIGMA2_PLI_DIR)/data/fonts/
endif	
	sed -e 's|#!/usr/bin/python|#!$(PTXDIST_SYSROOT_CROSS)/bin/python|' -i $(ENIGMA2_PLI_DIR)/po/xml2po.py
	cd $(ENIGMA2_PLI_DIR) && sh autogen.sh
	
	@$(call touch)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

ENIGMA2_PLI_PATH	:= PATH=$(CROSS_PATH)
ENIGMA2_PLI_ENV 	:= $(CROSS_ENV)


ifdef PTXCONF_ENIGMA2_PLI_ARP
ifdef PTXCONF_PLATFORM_SPARK
ENIGMA2_CONFIG_OPTS += --enable-spark
endif

ifdef PTXCONF_PLATFORM_SPARK7162
ENIGMA2_CONFIG_OPTS += --enable-spark7162
endif

ifdef PTXCONF_LIBEPLAYER3
ENIGMA2_CONFIG_OPTS += --enable-libeplayer3
else
ENIGMA2_CONFIG_OPTS += --enable-mediafwgstreamer
endif

ENIGMA2_PLI_AUTOCONF := \
	$(CROSS_AUTOCONF_USR) \
		--prefix=/usr \
		--without-libsdl \
		--with-boxtype=none \
		$(ENIGMA2_CONFIG_OPTS) \
		PYTHON=$(PTXDIST_SYSROOT_HOST)/bin/python2.7 \
		PY_PATH=$(SYSROOT)/usr \
		PKG_CONFIG=$(PTXDIST_SYSROOT_HOST)/bin/pkg-config \
		PKG_CONFIG_PATH=$(SYSROOT)/usr/lib/pkgconfig
else
ENIGMA2_PLI_AUTOCONF := \
	$(CROSS_AUTOCONF_USR) \
		--prefix=/usr \
		--without-libsdl \
		PYTHON=$(PTXDIST_SYSROOT_HOST)/bin/python2.7 \
		PY_PATH=$(SYSROOT)/usr \
		PKG_CONFIG=$(PTXDIST_SYSROOT_HOST)/bin/pkg-config \
		PKG_CONFIG_PATH=$(SYSROOT)/usr/lib/pkgconfig
endif

$(STATEDIR)/enigma2-pli.install.post:
	@$(call targetinfo)
	@$(call world/install.post, ENIGMA2_PLI)
	#sed -i "s/\/lib/\/local\/lib/g" $(SYSROOT)/usr/lib/pkgconfig/enigma2.pc
	#sed -i "s/\/include/\/local\/include/g" $(SYSROOT)/usr/lib/pkgconfig/enigma2.pc
	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/enigma2-pli.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,  enigma2-pli)
	@$(call install_fixup, enigma2-pli, PRIORITY,    optional)
	@$(call install_fixup, enigma2-pli, SECTION,     base)
	@$(call install_fixup, enigma2-pli, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup, enigma2-pli, DESCRIPTION, missing)
	
	@$(call install_copy, enigma2-pli, 0, 0, 755, -, /usr/bin/enigma2)
	@$(call install_copy, enigma2-pli, 0, 0, 644, -, /usr/lib/enigma2/python/mytest.py);
	
	@cd $(ENIGMA2_PLI_PKGDIR) && \
		find ./usr/lib/enigma2 \
		! -type d -a ! \( -name "*.py" -o -name "*.pyc" \) | \
		while read file; do \
		$(call install_copy, enigma2-pli, 0, 0, 644, -, $${file##.}); \
	done
	
	@$(call install_lib, enigma2-pli, 0, 0, 0644, libopen)
	
	#@$(call install_tree, enigma2-pli, 0, 0, -, /usr/local/share/)
	@cd $(ENIGMA2_PLI_PKGDIR) && \
		find ./usr/share \
		! -type d -a ! \( -name "keymap.xml" \) | \
		while read file; do \
		$(call install_copy, enigma2-pli, 0, 0, 644, -, $${file##.}); \
	done
	
	@$(call install_alternative_tree, enigma2-pli, 0, 0, /etc/enigma2)
	@$(call install_alternative_tree, enigma2-pli, 0, 0, /etc/tuxbox)
	@$(call install_link, enigma2-pli, /etc/tuxbox/timezone.xml, /etc/timezone.xml)
	
	@$(call install_finish, enigma2-pli)
	
	@$(call touch)


$(STATEDIR)/enigma2-pli-dev.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,  enigma2-pli-dev)
	@$(call install_fixup, enigma2-pli-dev, PRIORITY,    optional)
	@$(call install_fixup, enigma2-pli-dev, SECTION,     base)
	@$(call install_fixup, enigma2-pli-dev, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup, enigma2-pli-dev, DESCRIPTION, missing)
	
	@cd $(ENIGMA2_PLI_DEV_PKGDIR) && \
		find ./usr/lib/enigma2 -name "*.py" -a ! -name "mytest.py" | \
		while read file; do \
		$(call install_copy, enigma2-pli-dev, 0, 0, 644, -, $${file##.}); \
	done
	
	@$(call install_finish, enigma2-pli-dev)
	
	@$(call touch)

# ----------------------------------------------------------------------------
# Init
# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_PLI_INIT) += enigma2-pli-init

ENIGMA2_PLI_INIT_VERSION	:= head15

$(STATEDIR)/enigma2-pli-init.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init, enigma2-pli-init)
	@$(call install_fixup, enigma2-pli-init,PRIORITY,optional)
	@$(call install_fixup, enigma2-pli-init,SECTION,base)
	@$(call install_fixup, enigma2-pli-init,AUTHOR,"Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup, enigma2-pli-init,DESCRIPTION,missing)
	
ifdef PTXCONF_INITMETHOD_BBINIT
	@$(call install_alternative, enigma2-pli-init, 0, 0, 0755, /etc/init.d/enigma2)
	
ifneq ($(call remove_quotes,$(PTXCONF_ENIGMA2_PLI_BBINIT_LINK)),)
	@$(call install_link, enigma2-pli-init, \
		../init.d/enigma2, \
		/etc/rc.d/$(PTXCONF_ENIGMA2_PLI_BBINIT_LINK))
endif
endif
	
	@$(call install_finish, enigma2-pli-init)
	
	@$(call touch)

# vim: syntax=make
