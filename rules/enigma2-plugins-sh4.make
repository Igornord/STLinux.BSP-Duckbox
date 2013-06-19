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
PACKAGES-$(PTXCONF_ENIGMA2_PLUGINS_SH4) += enigma2-plugins-sh4

#
# Paths and names
#
ENIGMA2_PLUGINS_SH4_VERSION	:= HEAD
ENIGMA2_PLUGINS_SH4		:= enigma2-plugins-sh4-$(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_PLUGINS_SH4_URL	:= git://github.com/schpuntik/enigma2-plugins-sh4.git
ENIGMA2_PLUGINS_SH4_SOURCE_GIT	:= $(SRCDIR)/enigma2-plugins-sh4.git
ENIGMA2_PLUGINS_SH4_DIR	:= $(BUILDDIR)/$(ENIGMA2_PLUGINS_SH4) 
ENIGMA2_PLUGINS_SH4_LICENSE	:= GPLv2

$(STATEDIR)/enigma2-plugins-sh4.get:
	@$(call targetinfo)
	
	( \
		if [ -d $(ENIGMA2_PLUGINS_SH4_SOURCE_GIT) ]; then \
			cd $(ENIGMA2_PLUGINS_SH4_SOURCE_GIT); \
			git pull -u origin master 2>&1 > /dev/null; \
			git checkout HEAD 2>&1 > /dev/null; \
			cd -; \
		else \
			git clone $(ENIGMA2_PLUGINS_SH4_URL) $(ENIGMA2_PLUGINS_SH4_SOURCE_GIT) 2>&1 > /dev/null; \
		fi; \
	) 2>&1 > /dev/null
	
	( \
		if [ ! "$(ENIGMA2_PLUGINS_SH4_VERSION)" == "HEAD" ]; then \
			cd $(ENIGMA2_PLUGINS_SH4_SOURCE_GIT); \
			git checkout $(ENIGMA2_PLUGINS_SH4_VERSION) 2>&1 > /dev/null; \
			cd -; \
		fi; \
	) 2>&1 > /dev/null
	
	@$(call touch)

$(STATEDIR)/enigma2-plugins-sh4.extract:
	@$(call targetinfo)
	
	rm -rf $(BUILDDIR)/$(ENIGMA2_PLUGINS_SH4); \
	cp -a $(ENIGMA2_PLUGINS_SH4_SOURCE_GIT) $(BUILDDIR)/$(ENIGMA2_PLUGINS_SH4); \
	rm -rf $(BUILDDIR)/$(ENIGMA2_PLUGINS_SH4)/.git;
	
	#sed -i 's/hw.get_device_name().lower() != "dm7025"/False/g' $(BUILDDIR)/$(ENIGMA2_PLUGINS_SH4)/webinterface/src/plugin.py
	
	@$(call patchin, ENIGMA2_PLUGINS_SH4)
	
	cd $(ENIGMA2_PLUGINS_SH4_DIR); \
		cp $(PTXDIST_SYSROOT_HOST)/share/libtool/config/ltmain.sh .; \
		touch NEWS README AUTHORS ChangeLog; \
		autoreconf -i; #aclocal -I m4; autoheader; automake -a; autoconf; 
	
	@$(call touch)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

ENIGMA2_PLUGINS_SH4_PATH	:= PATH=$(CROSS_PATH)
ENIGMA2_PLUGINS_SH4_ENV 	:= $(CROSS_ENV)

ifdef PTXCONF_LIBEPLAYER3
ENIGMA2_PLUGINS_CONFIG_OPTS += --enable-libeplayer3
endif

#ENIGMA2_PLUGINS_SH4_CONF_TOOL	:= autoconf
ENIGMA2_PLUGINS_SH4_AUTOCONF := \
	$(CROSS_AUTOCONF_USR) \
	--prefix=/usr \
	--with-tpm \
	$(ENIGMA2_PLUGINS_CONFIG_OPTS) \
	PYTHON=$(PTXDIST_SYSROOT_HOST)/bin/python2.7 \
	PY_PATH=$(SYSROOT)/usr \
	PKG_CONFIG=$(PTXDIST_SYSROOT_HOST)/bin/pkg-config \
	PKG_CONFIG_PATH=$(SYSROOT)/usr/lib/pkgconfig

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

ifdef PTXCONF_ENIGMA2_PLUGINS_SH4

# ----------------------------------------------------------------------------
# Extensions
# ----------------------------------------------------------------------------

#for p in `ls .`; do echo -e "PACKAGES-\$(PTXCONF_ENIGMA2_EXTENSION_${p^^})  += enigma2-plugin-extensions-${p,,}\nENIGMA2_EXTENSION_${p^^}_VERSION              := \$(ENIGMA2_PLUGINS_SH4_VERSION)\nENIGMA2_EXTENSION_${p^^}_PKGDIR               := \$(ENIGMA2_PLUGINS_SH4_PKGDIR)\n\n\$(STATEDIR)/enigma2-plugin-extensions-${p,,}.targetinstall:\n\t@\$(call targetinfo)\n\t\n\t@\$(call install_init,   enigma2-plugin-extensions-${p,,})\n\t@\$(call install_fixup,  enigma2-plugin-extensions-${p,,}, PRIORITY,    optional)\n\t@\$(call install_fixup,  enigma2-plugin-extensions-${p,,}, SECTION,     base)\n\t@\$(call install_fixup,  enigma2-plugin-extensions-${p,,}, AUTHOR,      \"Robert Schwebel <r.schwebel@pengutronix.de>\")\n\t@\$(call install_fixup,  enigma2-plugin-extensions-${p,,}, DESCRIPTION, missing)\n\t\n\t@\$(call install_tree,   enigma2-plugin-extensions-${p,,}, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/${p})\n\t\n\t@\$(call install_finish, enigma2-plugin-extensions-${p,,})\n\t\n\t@\$(call touch)\n\n# ----------------------------------------------------------------------------"; done

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_ALTERNATIVESOFTCAMMANAGER)  += enigma2-plugin-extensions-alternativesoftcammanager
ENIGMA2_EXTENSION_ALTERNATIVESOFTCAMMANAGER_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_ALTERNATIVESOFTCAMMANAGER_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-alternativesoftcammanager.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-alternativesoftcammanager)
	@$(call install_fixup,  enigma2-plugin-extensions-alternativesoftcammanager, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-alternativesoftcammanager, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-alternativesoftcammanager, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-alternativesoftcammanager, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-alternativesoftcammanager, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/AlternativeSoftCamManager)
	
	@$(call install_finish, enigma2-plugin-extensions-alternativesoftcammanager)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_ANTISCROLLBAR)  += enigma2-plugin-extensions-antiscrollbar
ENIGMA2_EXTENSION_ANTISCROLLBAR_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_ANTISCROLLBAR_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-antiscrollbar.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-antiscrollbar)
	@$(call install_fixup,  enigma2-plugin-extensions-antiscrollbar, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-antiscrollbar, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-antiscrollbar, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-antiscrollbar, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-antiscrollbar, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/AntiScrollbar)
	
	@$(call install_finish, enigma2-plugin-extensions-antiscrollbar)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_AUDIOSYNC)  += enigma2-plugin-extensions-audiosync
ENIGMA2_EXTENSION_AUDIOSYNC_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_AUDIOSYNC_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-audiosync.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-audiosync)
	@$(call install_fixup,  enigma2-plugin-extensions-audiosync, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-audiosync, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-audiosync, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-audiosync, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-audiosync, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/AudioSync)
	
	@$(call install_finish, enigma2-plugin-extensions-audiosync)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_AUTOTIMER)  += enigma2-plugin-extensions-autotimer
ENIGMA2_EXTENSION_AUTOTIMER_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_AUTOTIMER_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-autotimer.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-autotimer)
	@$(call install_fixup,  enigma2-plugin-extensions-autotimer, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-autotimer, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-autotimer, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-autotimer, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-autotimer, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/AutoTimer)
	
	@$(call install_finish, enigma2-plugin-extensions-autotimer)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_BABELZAPPER)  += enigma2-plugin-extensions-babelzapper
ENIGMA2_EXTENSION_BABELZAPPER_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_BABELZAPPER_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-babelzapper.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-babelzapper)
	@$(call install_fixup,  enigma2-plugin-extensions-babelzapper, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-babelzapper, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-babelzapper, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-babelzapper, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-babelzapper, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/BabelZapper)
	
	@$(call install_finish, enigma2-plugin-extensions-babelzapper)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_BITRATEVIEWER)  += enigma2-plugin-extensions-bitrateviewer
ENIGMA2_EXTENSION_BITRATEVIEWER_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_BITRATEVIEWER_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-bitrateviewer.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-bitrateviewer)
	@$(call install_fixup,  enigma2-plugin-extensions-bitrateviewer, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-bitrateviewer, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-bitrateviewer, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-bitrateviewer, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-bitrateviewer, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/BitrateViewer)
	
	@$(call install_finish, enigma2-plugin-extensions-bitrateviewer)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_BONJOUR)  += enigma2-plugin-extensions-bonjour
ENIGMA2_EXTENSION_BONJOUR_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_BONJOUR_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-bonjour.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-bonjour)
	@$(call install_fixup,  enigma2-plugin-extensions-bonjour, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-bonjour, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-bonjour, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-bonjour, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-bonjour, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/Bonjour)
	
	@$(call install_finish, enigma2-plugin-extensions-bonjour)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_CDINFO)  += enigma2-plugin-extensions-cdinfo
ENIGMA2_EXTENSION_CDINFO_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_CDINFO_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-cdinfo.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-cdinfo)
	@$(call install_fixup,  enigma2-plugin-extensions-cdinfo, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-cdinfo, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-cdinfo, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-cdinfo, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-cdinfo, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/CDInfo)
	
	@$(call install_finish, enigma2-plugin-extensions-cdinfo)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_CURLYTX)  += enigma2-plugin-extensions-curlytx
ENIGMA2_EXTENSION_CURLYTX_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_CURLYTX_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-curlytx.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-curlytx)
	@$(call install_fixup,  enigma2-plugin-extensions-curlytx, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-curlytx, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-curlytx, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-curlytx, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-curlytx, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/CDInfo)
	
	@$(call install_finish, enigma2-plugin-extensions-curlytx)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_DREAMIRC)  += enigma2-plugin-extensions-dreamirc
ENIGMA2_EXTENSION_DREAMIRC_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_DREAMIRC_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-dreamirc.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-dreamirc)
	@$(call install_fixup,  enigma2-plugin-extensions-dreamirc, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-dreamirc, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-dreamirc, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-dreamirc, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-dreamirc, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/dreamIRC)
	
	@$(call install_finish, enigma2-plugin-extensions-dreamirc)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_DREAMMEDIATHEK)  += enigma2-plugin-extensions-dreammediathek
ENIGMA2_EXTENSION_DREAMMEDIATHEK_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_DREAMMEDIATHEK_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-dreammediathek.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-dreammediathek)
	@$(call install_fixup,  enigma2-plugin-extensions-dreammediathek, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-dreammediathek, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-dreammediathek, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-dreammediathek, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-dreammediathek, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/dreamMediathek)
	
	@$(call install_finish, enigma2-plugin-extensions-dreammediathek)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_DVDBACKUP)  += enigma2-plugin-extensions-dvdbackup
ENIGMA2_EXTENSION_DVDBACKUP_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_DVDBACKUP_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-dvdbackup.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-dvdbackup)
	@$(call install_fixup,  enigma2-plugin-extensions-dvdbackup, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-dvdbackup, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-dvdbackup, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-dvdbackup, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-dvdbackup, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/DVDBackup)
	
	@$(call install_finish, enigma2-plugin-extensions-dvdbackup)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_DYNDNS)  += enigma2-plugin-extensions-dyndns
ENIGMA2_EXTENSION_DYNDNS_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_DYNDNS_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-dyndns.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-dyndns)
	@$(call install_fixup,  enigma2-plugin-extensions-dyndns, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-dyndns, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-dyndns, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-dyndns, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-dyndns, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/DynDNS)
	
	@$(call install_finish, enigma2-plugin-extensions-dyndns)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_EASYINFO)  += enigma2-plugin-extensions-easyinfo
ENIGMA2_EXTENSION_EASYINFO_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_EASYINFO_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-easyinfo.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-easyinfo)
	@$(call install_fixup,  enigma2-plugin-extensions-easyinfo, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-easyinfo, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-easyinfo, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-easyinfo, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-easyinfo, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/EasyInfo)
	
	@$(call install_finish, enigma2-plugin-extensions-easyinfo)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_EASYMEDIA)  += enigma2-plugin-extensions-easymedia
ENIGMA2_EXTENSION_EASYMEDIA_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_EASYMEDIA_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-easymedia.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-easymedia)
	@$(call install_fixup,  enigma2-plugin-extensions-easymedia, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-easymedia, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-easymedia, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-easymedia, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-easymedia, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/EasyMedia)
	
	@$(call install_finish, enigma2-plugin-extensions-easymedia)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_ECASA)  += enigma2-plugin-extensions-ecasa
ENIGMA2_EXTENSION_ECASA_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_ECASA_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-ecasa.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-ecasa)
	@$(call install_fixup,  enigma2-plugin-extensions-ecasa, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-ecasa, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-ecasa, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-ecasa, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-ecasa, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/Ecasa)
	
	@$(call install_finish, enigma2-plugin-extensions-ecasa)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_EIBOX)  += enigma2-plugin-extensions-eibox
ENIGMA2_EXTENSION_EIBOX_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_EIBOX_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-eibox.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-eibox)
	@$(call install_fixup,  enigma2-plugin-extensions-eibox, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-eibox, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-eibox, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-eibox, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-eibox, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/EIBox)
	
	@$(call install_finish, enigma2-plugin-extensions-eibox)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_ELEKTRO)  += enigma2-plugin-extensions-elektro
ENIGMA2_EXTENSION_ELEKTRO_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_ELEKTRO_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-elektro.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-elektro)
	@$(call install_fixup,  enigma2-plugin-extensions-elektro, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-elektro, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-elektro, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-elektro, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-elektro, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/Elektro)
	
	@$(call install_finish, enigma2-plugin-extensions-elektro)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_EMAILCLIENT)  += enigma2-plugin-extensions-emailclient
ENIGMA2_EXTENSION_EMAILCLIENT_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_EMAILCLIENT_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-emailclient.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-emailclient)
	@$(call install_fixup,  enigma2-plugin-extensions-emailclient, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-emailclient, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-emailclient, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-emailclient, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-emailclient, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/EmailClient)
	
	@$(call install_finish, enigma2-plugin-extensions-emailclient)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_EMISSION)  += enigma2-plugin-extensions-emission
ENIGMA2_EXTENSION_EMISSION_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_EMISSION_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-emission.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-emission)
	@$(call install_fixup,  enigma2-plugin-extensions-emission, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-emission, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-emission, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-emission, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-emission, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/Emission)
	
	@$(call install_finish, enigma2-plugin-extensions-emission)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_EPGREFRESH)  += enigma2-plugin-extensions-epgrefresh
ENIGMA2_EXTENSION_EPGREFRESH_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_EPGREFRESH_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-epgrefresh.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-epgrefresh)
	@$(call install_fixup,  enigma2-plugin-extensions-epgrefresh, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-epgrefresh, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-epgrefresh, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-epgrefresh, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-epgrefresh, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/EPGRefresh)
	
	@$(call install_finish, enigma2-plugin-extensions-epgrefresh)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_EPGSEARCH)  += enigma2-plugin-extensions-epgsearch
ENIGMA2_EXTENSION_EPGSEARCH_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_EPGSEARCH_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-epgsearch.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-epgsearch)
	@$(call install_fixup,  enigma2-plugin-extensions-epgsearch, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-epgsearch, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-epgsearch, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-epgsearch, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-epgsearch, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/EPGSearch)
	
	@$(call install_finish, enigma2-plugin-extensions-epgsearch)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_EUROTICTV)  += enigma2-plugin-extensions-eurotictv
ENIGMA2_EXTENSION_EUROTICTV_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_EUROTICTV_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-eurotictv.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-eurotictv)
	@$(call install_fixup,  enigma2-plugin-extensions-eurotictv, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-eurotictv, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-eurotictv, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-eurotictv, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-eurotictv, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/eUroticTV)
	
	@$(call install_finish, enigma2-plugin-extensions-eurotictv)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_FILEBROWSER)  += enigma2-plugin-extensions-filebrowser
ENIGMA2_EXTENSION_FILEBROWSER_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_FILEBROWSER_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-filebrowser.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-filebrowser)
	@$(call install_fixup,  enigma2-plugin-extensions-filebrowser, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-filebrowser, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-filebrowser, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-filebrowser, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-filebrowser, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/Filebrowser)
	
	@$(call install_finish, enigma2-plugin-extensions-filebrowser)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_FRITZCALL)  += enigma2-plugin-extensions-fritzcall
ENIGMA2_EXTENSION_FRITZCALL_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_FRITZCALL_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-fritzcall.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-fritzcall)
	@$(call install_fixup,  enigma2-plugin-extensions-fritzcall, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-fritzcall, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-fritzcall, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-fritzcall, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-fritzcall, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/FritzCall)
	
	@$(call install_finish, enigma2-plugin-extensions-fritzcall)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_FSTABEDITOR)  += enigma2-plugin-extensions-fstabeditor
ENIGMA2_EXTENSION_FSTABEDITOR_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_FSTABEDITOR_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-fstabeditor.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-fstabeditor)
	@$(call install_fixup,  enigma2-plugin-extensions-fstabeditor, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-fstabeditor, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-fstabeditor, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-fstabeditor, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-fstabeditor, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/fstabEditor)
	
	@$(call install_finish, enigma2-plugin-extensions-fstabeditor)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_FTPBROWSER)  += enigma2-plugin-extensions-ftpbrowser
ENIGMA2_EXTENSION_FTPBROWSER_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_FTPBROWSER_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-ftpbrowser.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-ftpbrowser)
	@$(call install_fixup,  enigma2-plugin-extensions-ftpbrowser, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-ftpbrowser, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-ftpbrowser, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-ftpbrowser, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-ftpbrowser, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/FTPBrowser)
	
	@$(call install_finish, enigma2-plugin-extensions-ftpbrowser)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_GOOGLEMAPS)  += enigma2-plugin-extensions-googlemaps
ENIGMA2_EXTENSION_GOOGLEMAPS_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_GOOGLEMAPS_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-googlemaps.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-googlemaps)
	@$(call install_fixup,  enigma2-plugin-extensions-googlemaps, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-googlemaps, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-googlemaps, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-googlemaps, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-googlemaps, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/GoogleMaps)
	
	@$(call install_finish, enigma2-plugin-extensions-googlemaps)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_GROWLEE)  += enigma2-plugin-extensions-growlee
ENIGMA2_EXTENSION_GROWLEE_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_GROWLEE_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-growlee.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-growlee)
	@$(call install_fixup,  enigma2-plugin-extensions-growlee, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-growlee, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-growlee, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-growlee, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-growlee, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/Growlee)
	
	@$(call install_finish, enigma2-plugin-extensions-growlee)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_HTTPPROXY)  += enigma2-plugin-extensions-httpproxy
ENIGMA2_EXTENSION_HTTPPROXY_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_HTTPPROXY_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-httpproxy.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-httpproxy)
	@$(call install_fixup,  enigma2-plugin-extensions-httpproxy, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-httpproxy, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-httpproxy, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-httpproxy, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-httpproxy, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/HTTPProxy)
	
	@$(call install_finish, enigma2-plugin-extensions-httpproxy)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_IMDB)  += enigma2-plugin-extensions-imdb
ENIGMA2_EXTENSION_IMDB_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_IMDB_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-imdb.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-imdb)
	@$(call install_fixup,  enigma2-plugin-extensions-imdb, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-imdb, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-imdb, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-imdb, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-imdb, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/IMDb)
	
	@$(call install_finish, enigma2-plugin-extensions-imdb)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_INFOBARTUNERSTATE)  += enigma2-plugin-extensions-infobartunerstate
ENIGMA2_EXTENSION_INFOBARTUNERSTATE_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_INFOBARTUNERSTATE_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-infobartunerstate.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-infobartunerstate)
	@$(call install_fixup,  enigma2-plugin-extensions-infobartunerstate, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-infobartunerstate, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-infobartunerstate, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-infobartunerstate, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-infobartunerstate, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/InfoBarTunerState)
	
	@$(call install_finish, enigma2-plugin-extensions-infobartunerstate)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_KIDDYTIMER)  += enigma2-plugin-extensions-kiddytimer
ENIGMA2_EXTENSION_KIDDYTIMER_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_KIDDYTIMER_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-kiddytimer.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-kiddytimer)
	@$(call install_fixup,  enigma2-plugin-extensions-kiddytimer, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-kiddytimer, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-kiddytimer, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-kiddytimer, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-kiddytimer, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/KiddyTimer)
	
	@$(call install_finish, enigma2-plugin-extensions-kiddytimer)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_LASTFM)  += enigma2-plugin-extensions-lastfm
ENIGMA2_EXTENSION_LASTFM_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_LASTFM_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-lastfm.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-lastfm)
	@$(call install_fixup,  enigma2-plugin-extensions-lastfm, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-lastfm, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-lastfm, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-lastfm, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-lastfm, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/LastFM)
	
	@$(call install_finish, enigma2-plugin-extensions-lastfm)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_LETTERBOX)  += enigma2-plugin-extensions-letterbox
ENIGMA2_EXTENSION_LETTERBOX_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_LETTERBOX_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-letterbox.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-letterbox)
	@$(call install_fixup,  enigma2-plugin-extensions-letterbox, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-letterbox, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-letterbox, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-letterbox, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-letterbox, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/LetterBox)
	
	@$(call install_finish, enigma2-plugin-extensions-letterbox)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_LOGOMANAGER)  += enigma2-plugin-extensions-logomanager
ENIGMA2_EXTENSION_LOGOMANAGER_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_LOGOMANAGER_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-logomanager.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-logomanager)
	@$(call install_fixup,  enigma2-plugin-extensions-logomanager, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-logomanager, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-logomanager, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-logomanager, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-logomanager, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/LogoManager)
	
	@$(call install_finish, enigma2-plugin-extensions-logomanager)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_MEDIADOWNLOADER)  += enigma2-plugin-extensions-mediadownloader
ENIGMA2_EXTENSION_MEDIADOWNLOADER_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_MEDIADOWNLOADER_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-mediadownloader.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-mediadownloader)
	@$(call install_fixup,  enigma2-plugin-extensions-mediadownloader, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-mediadownloader, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-mediadownloader, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-mediadownloader, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-mediadownloader, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/MediaDownloader)
	
	@$(call install_finish, enigma2-plugin-extensions-mediadownloader)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_MERLINEPG)  += enigma2-plugin-extensions-merlinepg
ENIGMA2_EXTENSION_MERLINEPG_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_MERLINEPG_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-merlinepg.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-merlinepg)
	@$(call install_fixup,  enigma2-plugin-extensions-merlinepg, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-merlinepg, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-merlinepg, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-merlinepg, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-merlinepg, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/MerlinEPG)
	
	@$(call install_finish, enigma2-plugin-extensions-merlinepg)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_MERLINEPGCENTER)  += enigma2-plugin-extensions-merlinepgcenter
ENIGMA2_EXTENSION_MERLINEPGCENTER_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_MERLINEPGCENTER_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-merlinepgcenter.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-merlinepgcenter)
	@$(call install_fixup,  enigma2-plugin-extensions-merlinepgcenter, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-merlinepgcenter, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-merlinepgcenter, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-merlinepgcenter, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-merlinepgcenter, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/MerlinEPGCenter)
	
	@$(call install_finish, enigma2-plugin-extensions-merlinepgcenter)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_METEOITALIA)  += enigma2-plugin-extensions-meteoitalia
ENIGMA2_EXTENSION_METEOITALIA_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_METEOITALIA_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-meteoitalia.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-meteoitalia)
	@$(call install_fixup,  enigma2-plugin-extensions-meteoitalia, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-meteoitalia, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-meteoitalia, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-meteoitalia, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-meteoitalia, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/MeteoItalia)
	
	@$(call install_finish, enigma2-plugin-extensions-meteoitalia)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_MOSAIC)  += enigma2-plugin-extensions-mosaic
ENIGMA2_EXTENSION_MOSAIC_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_MOSAIC_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-mosaic.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-mosaic)
	@$(call install_fixup,  enigma2-plugin-extensions-mosaic, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-mosaic, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-mosaic, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-mosaic, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-mosaic, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/Mosaic)
	
	@$(call install_finish, enigma2-plugin-extensions-mosaic)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_MOVIECUT)  += enigma2-plugin-extensions-moviecut
ENIGMA2_EXTENSION_MOVIECUT_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_MOVIECUT_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-moviecut.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-moviecut)
	@$(call install_fixup,  enigma2-plugin-extensions-moviecut, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-moviecut, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-moviecut, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-moviecut, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-moviecut, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/MovieCut)
	
	@$(call install_finish, enigma2-plugin-extensions-moviecut)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_MOVIERETITLE)  += enigma2-plugin-extensions-movieretitle
ENIGMA2_EXTENSION_MOVIERETITLE_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_MOVIERETITLE_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-movieretitle.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-movieretitle)
	@$(call install_fixup,  enigma2-plugin-extensions-movieretitle, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-movieretitle, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-movieretitle, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-movieretitle, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-movieretitle, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/MovieRetitle)
	
	@$(call install_finish, enigma2-plugin-extensions-movieretitle)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_MOVIESEARCH)  += enigma2-plugin-extensions-moviesearch
ENIGMA2_EXTENSION_MOVIESEARCH_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_MOVIESEARCH_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-moviesearch.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-moviesearch)
	@$(call install_fixup,  enigma2-plugin-extensions-moviesearch, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-moviesearch, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-moviesearch, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-moviesearch, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-moviesearch, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/MovieSearch)
	
	@$(call install_finish, enigma2-plugin-extensions-moviesearch)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_MOVIESELECTIONQUICKBUTTON)  += enigma2-plugin-extensions-movieselectionquickbutton
ENIGMA2_EXTENSION_MOVIESELECTIONQUICKBUTTON_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_MOVIESELECTIONQUICKBUTTON_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-movieselectionquickbutton.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-movieselectionquickbutton)
	@$(call install_fixup,  enigma2-plugin-extensions-movieselectionquickbutton, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-movieselectionquickbutton, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-movieselectionquickbutton, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-movieselectionquickbutton, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-movieselectionquickbutton, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/MovieSelectionQuickButton)
	
	@$(call install_finish, enigma2-plugin-extensions-movieselectionquickbutton)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_MOVIETAGGER)  += enigma2-plugin-extensions-movietagger
ENIGMA2_EXTENSION_MOVIETAGGER_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_MOVIETAGGER_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-movietagger.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-movietagger)
	@$(call install_fixup,  enigma2-plugin-extensions-movietagger, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-movietagger, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-movietagger, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-movietagger, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-movietagger, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/MovieTagger)
	
	@$(call install_finish, enigma2-plugin-extensions-movietagger)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_MULTIQUICKBUTTON)  += enigma2-plugin-extensions-multiquickbutton
ENIGMA2_EXTENSION_MULTIQUICKBUTTON_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_MULTIQUICKBUTTON_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-multiquickbutton.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-multiquickbutton)
	@$(call install_fixup,  enigma2-plugin-extensions-multiquickbutton, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-multiquickbutton, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-multiquickbutton, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-multiquickbutton, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-multiquickbutton, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/MultiQuickButton)
	
	@$(call install_finish, enigma2-plugin-extensions-multiquickbutton)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_MULTIRC)  += enigma2-plugin-extensions-multirc
ENIGMA2_EXTENSION_MULTIRC_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_MULTIRC_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-multirc.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-multirc)
	@$(call install_fixup,  enigma2-plugin-extensions-multirc, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-multirc, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-multirc, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-multirc, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-multirc, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/MultiRC)
	
	@$(call install_finish, enigma2-plugin-extensions-multirc)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_MYTUBE)  += enigma2-plugin-extensions-mytube
ENIGMA2_EXTENSION_MYTUBE_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_MYTUBE_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-mytube.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-mytube)
	@$(call install_fixup,  enigma2-plugin-extensions-mytube, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-mytube, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-mytube, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-mytube, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-mytube, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/MyTube)
	
	@$(call install_finish, enigma2-plugin-extensions-mytube)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_NAMEZAP)  += enigma2-plugin-extensions-namezap
ENIGMA2_EXTENSION_NAMEZAP_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_NAMEZAP_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-namezap.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-namezap)
	@$(call install_fixup,  enigma2-plugin-extensions-namezap, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-namezap, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-namezap, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-namezap, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-namezap, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/MyTube)
	
	@$(call install_finish, enigma2-plugin-extensions-namezap)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_NCIDCLIENT)  += enigma2-plugin-extensions-ncidclient
ENIGMA2_EXTENSION_NCIDCLIENT_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_NCIDCLIENT_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-ncidclient.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-ncidclient)
	@$(call install_fixup,  enigma2-plugin-extensions-ncidclient, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-ncidclient, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-ncidclient, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-ncidclient, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-ncidclient, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/NcidClient)
	
	@$(call install_finish, enigma2-plugin-extensions-ncidclient)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_NETCASTER)  += enigma2-plugin-extensions-netcaster
ENIGMA2_EXTENSION_NETCASTER_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_NETCASTER_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-netcaster.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-netcaster)
	@$(call install_fixup,  enigma2-plugin-extensions-netcaster, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-netcaster, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-netcaster, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-netcaster, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-netcaster, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/NETcaster)
	
	@$(call install_finish, enigma2-plugin-extensions-netcaster)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_OFDB)  += enigma2-plugin-extensions-ofdb
ENIGMA2_EXTENSION_OFDB_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_OFDB_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-ofdb.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-ofdb)
	@$(call install_fixup,  enigma2-plugin-extensions-ofdb, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-ofdb, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-ofdb, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-ofdb, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-ofdb, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/OFDb)
	
	@$(call install_finish, enigma2-plugin-extensions-ofdb)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_ORFAT)  += enigma2-plugin-extensions-orfat
ENIGMA2_EXTENSION_ORFAT_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_ORFAT_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-orfat.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-orfat)
	@$(call install_fixup,  enigma2-plugin-extensions-orfat, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-orfat, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-orfat, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-orfat, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-orfat, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/ORFat)
	
	@$(call install_finish, enigma2-plugin-extensions-orfat)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_ORFTELETEXT)  += enigma2-plugin-extensions-orfteletext
ENIGMA2_EXTENSION_ORFTELETEXT_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_ORFTELETEXT_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-orfteletext.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-orfteletext)
	@$(call install_fixup,  enigma2-plugin-extensions-orfteletext, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-orfteletext, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-orfteletext, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-orfteletext, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-orfteletext, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/ORFteletext)
	
	@$(call install_finish, enigma2-plugin-extensions-orfteletext)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_PARTNERBOX)  += enigma2-plugin-extensions-partnerbox
ENIGMA2_EXTENSION_PARTNERBOX_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_PARTNERBOX_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-partnerbox.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-partnerbox)
	@$(call install_fixup,  enigma2-plugin-extensions-partnerbox, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-partnerbox, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-partnerbox, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-partnerbox, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-partnerbox, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/Partnerbox)
	
	@$(call install_finish, enigma2-plugin-extensions-partnerbox)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_PERMANENTCLOCK)  += enigma2-plugin-extensions-permanentclock
ENIGMA2_EXTENSION_PERMANENTCLOCK_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_PERMANENTCLOCK_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-permanentclock.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-permanentclock)
	@$(call install_fixup,  enigma2-plugin-extensions-permanentclock, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-permanentclock, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-permanentclock, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-permanentclock, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-permanentclock, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/PermanentClock)
	
	@$(call install_finish, enigma2-plugin-extensions-permanentclock)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_PERMANENTTIMESHIFT)  += enigma2-plugin-extensions-permanenttimeshift
ENIGMA2_EXTENSION_PERMANENTTIMESHIFT_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_PERMANENTTIMESHIFT_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-permanenttimeshift.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-permanenttimeshift)
	@$(call install_fixup,  enigma2-plugin-extensions-permanenttimeshift, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-permanenttimeshift, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-permanenttimeshift, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-permanenttimeshift, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-permanenttimeshift, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/PermanentTimeshift)
	
	@$(call install_finish, enigma2-plugin-extensions-permanenttimeshift)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_PIPSERVICERELATION)  += enigma2-plugin-extensions-pipservicerelation
ENIGMA2_EXTENSION_PIPSERVICERELATION_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_PIPSERVICERELATION_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-pipservicerelation.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-pipservicerelation)
	@$(call install_fixup,  enigma2-plugin-extensions-pipservicerelation, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-pipservicerelation, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-pipservicerelation, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-pipservicerelation, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-pipservicerelation, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/PiPServiceRelation)
	
	@$(call install_finish, enigma2-plugin-extensions-pipservicerelation)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_PIPZAP)  += enigma2-plugin-extensions-pipzap
ENIGMA2_EXTENSION_PIPZAP_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_PIPZAP_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-pipzap.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-pipzap)
	@$(call install_fixup,  enigma2-plugin-extensions-pipzap, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-pipzap, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-pipzap, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-pipzap, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-pipzap, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/pipzap)
	
	@$(call install_finish, enigma2-plugin-extensions-pipzap)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_PLUGINHIDER)  += enigma2-plugin-extensions-pluginhider
ENIGMA2_EXTENSION_PLUGINHIDER_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_PLUGINHIDER_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-pluginhider.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-pluginhider)
	@$(call install_fixup,  enigma2-plugin-extensions-pluginhider, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-pluginhider, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-pluginhider, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-pluginhider, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-pluginhider, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/PluginHider)
	
	@$(call install_finish, enigma2-plugin-extensions-pluginhider)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_PLUGINSORT)  += enigma2-plugin-extensions-pluginsort
ENIGMA2_EXTENSION_PLUGINSORT_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_PLUGINSORT_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-pluginsort.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-pluginsort)
	@$(call install_fixup,  enigma2-plugin-extensions-pluginsort, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-pluginsort, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-pluginsort, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-pluginsort, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-pluginsort, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/PluginSort)
	
	@$(call install_finish, enigma2-plugin-extensions-pluginsort)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_PODCAST)  += enigma2-plugin-extensions-podcast
ENIGMA2_EXTENSION_PODCAST_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_PODCAST_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-podcast.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-podcast)
	@$(call install_fixup,  enigma2-plugin-extensions-podcast, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-podcast, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-podcast, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-podcast, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-podcast, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/Podcast)
	
	@$(call install_finish, enigma2-plugin-extensions-podcast)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_PORNCENTER)  += enigma2-plugin-extensions-porncenter
ENIGMA2_EXTENSION_PORNCENTER_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_PORNCENTER_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-porncenter.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-porncenter)
	@$(call install_fixup,  enigma2-plugin-extensions-porncenter, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-porncenter, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-porncenter, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-porncenter, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-porncenter, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/PornCenter)
	
	@$(call install_finish, enigma2-plugin-extensions-porncenter)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_QUICKBUTTON)  += enigma2-plugin-extensions-quickbutton
ENIGMA2_EXTENSION_QUICKBUTTON_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_QUICKBUTTON_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-quickbutton.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-quickbutton)
	@$(call install_fixup,  enigma2-plugin-extensions-quickbutton, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-quickbutton, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-quickbutton, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-quickbutton, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-quickbutton, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/Quickbutton)
	
	@$(call install_finish, enigma2-plugin-extensions-quickbutton)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_QUICKEPG)  += enigma2-plugin-extensions-quickepg
ENIGMA2_EXTENSION_QUICKEPG_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_QUICKEPG_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-quickepg.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-quickepg)
	@$(call install_fixup,  enigma2-plugin-extensions-quickepg, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-quickepg, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-quickepg, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-quickepg, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-quickepg, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/QuickEPG)
	
	@$(call install_finish, enigma2-plugin-extensions-quickepg)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_RECONSTRUCTAPSC)  += enigma2-plugin-extensions-reconstructapsc
ENIGMA2_EXTENSION_RECONSTRUCTAPSC_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_RECONSTRUCTAPSC_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-reconstructapsc.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-reconstructapsc)
	@$(call install_fixup,  enigma2-plugin-extensions-reconstructapsc, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-reconstructapsc, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-reconstructapsc, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-reconstructapsc, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-reconstructapsc, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/ReconstructApSc)
	
	@$(call install_finish, enigma2-plugin-extensions-reconstructapsc)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_REMOTETIMER)  += enigma2-plugin-extensions-remotetimer
ENIGMA2_EXTENSION_REMOTETIMER_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_REMOTETIMER_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-remotetimer.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-remotetimer)
	@$(call install_fixup,  enigma2-plugin-extensions-remotetimer, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-remotetimer, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-remotetimer, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-remotetimer, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-remotetimer, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/remoteTimer)
	
	@$(call install_finish, enigma2-plugin-extensions-remotetimer)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_RSDOWNLOADER)  += enigma2-plugin-extensions-rsdownloader
ENIGMA2_EXTENSION_RSDOWNLOADER_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_RSDOWNLOADER_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-rsdownloader.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-rsdownloader)
	@$(call install_fixup,  enigma2-plugin-extensions-rsdownloader, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-rsdownloader, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-rsdownloader, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-rsdownloader, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-rsdownloader, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/RSDownloader)
	
	@$(call install_finish, enigma2-plugin-extensions-rsdownloader)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_SEEKBAR)  += enigma2-plugin-extensions-seekbar
ENIGMA2_EXTENSION_SEEKBAR_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_SEEKBAR_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-seekbar.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-seekbar)
	@$(call install_fixup,  enigma2-plugin-extensions-seekbar, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-seekbar, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-seekbar, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-seekbar, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-seekbar, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/Seekbar)
	
	@$(call install_finish, enigma2-plugin-extensions-seekbar)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_SERIENFILM)  += enigma2-plugin-extensions-serienfilm
ENIGMA2_EXTENSION_SERIENFILM_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_SERIENFILM_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-serienfilm.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-serienfilm)
	@$(call install_fixup,  enigma2-plugin-extensions-serienfilm, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-serienfilm, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-serienfilm, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-serienfilm, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-serienfilm, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/SerienFilm)
	
	@$(call install_finish, enigma2-plugin-extensions-serienfilm)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_SHOUTCAST)  += enigma2-plugin-extensions-shoutcast
ENIGMA2_EXTENSION_SHOUTCAST_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_SHOUTCAST_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-shoutcast.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-shoutcast)
	@$(call install_fixup,  enigma2-plugin-extensions-shoutcast, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-shoutcast, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-shoutcast, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-shoutcast, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-shoutcast, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/SHOUTcast)
	
	@$(call install_finish, enigma2-plugin-extensions-shoutcast)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_SHOWCLOCK)  += enigma2-plugin-extensions-showclock
ENIGMA2_EXTENSION_SHOWCLOCK_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_SHOWCLOCK_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-showclock.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-showclock)
	@$(call install_fixup,  enigma2-plugin-extensions-showclock, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-showclock, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-showclock, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-showclock, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-showclock, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/ShowClock)
	
	@$(call install_finish, enigma2-plugin-extensions-showclock)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_SIMPLERSS)  += enigma2-plugin-extensions-simplerss
ENIGMA2_EXTENSION_SIMPLERSS_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_SIMPLERSS_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-simplerss.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-simplerss)
	@$(call install_fixup,  enigma2-plugin-extensions-simplerss, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-simplerss, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-simplerss, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-simplerss, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-simplerss, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/SimpleRSS)
	
	@$(call install_finish, enigma2-plugin-extensions-simplerss)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_SUBSDOWNLOADER2)  += enigma2-plugin-extensions-subsdownloader2
ENIGMA2_EXTENSION_SUBSDOWNLOADER2_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_SUBSDOWNLOADER2_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-subsdownloader2.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-subsdownloader2)
	@$(call install_fixup,  enigma2-plugin-extensions-subsdownloader2, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-subsdownloader2, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-subsdownloader2, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-subsdownloader2, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-subsdownloader2, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/SubsDownloader2)
	
	@$(call install_finish, enigma2-plugin-extensions-subsdownloader2)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_STARTUPTOSTANDBY)  += enigma2-plugin-extensions-startuptostandby
ENIGMA2_EXTENSION_STARTUPTOSTANDBY_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_STARTUPTOSTANDBY_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-startuptostandby.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-startuptostandby)
	@$(call install_fixup,  enigma2-plugin-extensions-startuptostandby, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-startuptostandby, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-startuptostandby, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-startuptostandby, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-startuptostandby, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/StartupToStandby)
	
	@$(call install_finish, enigma2-plugin-extensions-startuptostandby)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_SVDRP)  += enigma2-plugin-extensions-svdrp
ENIGMA2_EXTENSION_SVDRP_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_SVDRP_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-svdrp.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-svdrp)
	@$(call install_fixup,  enigma2-plugin-extensions-svdrp, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-svdrp, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-svdrp, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-svdrp, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-svdrp, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/SVDRP)
	
	@$(call install_finish, enigma2-plugin-extensions-svdrp)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_TAGEDITOR)  += enigma2-plugin-extensions-tageditor
ENIGMA2_EXTENSION_TAGEDITOR_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_TAGEDITOR_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-tageditor.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-tageditor)
	@$(call install_fixup,  enigma2-plugin-extensions-tageditor, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-tageditor, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-tageditor, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-tageditor, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-tageditor, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/TagEditor)
	
	@$(call install_finish, enigma2-plugin-extensions-tageditor)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_TRAFFICINFO)  += enigma2-plugin-extensions-trafficinfo
ENIGMA2_EXTENSION_TRAFFICINFO_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_TRAFFICINFO_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-trafficinfo.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-trafficinfo)
	@$(call install_fixup,  enigma2-plugin-extensions-trafficinfo, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-trafficinfo, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-trafficinfo, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-trafficinfo, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-trafficinfo, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/TrafficInfo)
	
	@$(call install_finish, enigma2-plugin-extensions-trafficinfo)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_TVCHARTS)  += enigma2-plugin-extensions-tvcharts
ENIGMA2_EXTENSION_TVCHARTS_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_TVCHARTS_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-tvcharts.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-tvcharts)
	@$(call install_fixup,  enigma2-plugin-extensions-tvcharts, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-tvcharts, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-tvcharts, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-tvcharts, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-tvcharts, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/TVCharts)
	
	@$(call install_finish, enigma2-plugin-extensions-tvcharts)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_UNWETTERINFO)  += enigma2-plugin-extensions-unwetterinfo
ENIGMA2_EXTENSION_UNWETTERINFO_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_UNWETTERINFO_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-unwetterinfo.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-unwetterinfo)
	@$(call install_fixup,  enigma2-plugin-extensions-unwetterinfo, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-unwetterinfo, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-unwetterinfo, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-unwetterinfo, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-unwetterinfo, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/UnwetterInfo)
	
	@$(call install_finish, enigma2-plugin-extensions-unwetterinfo)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_VALIXDCONTROL)  += enigma2-plugin-extensions-valixdcontrol
ENIGMA2_EXTENSION_VALIXDCONTROL_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_VALIXDCONTROL_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-valixdcontrol.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-valixdcontrol)
	@$(call install_fixup,  enigma2-plugin-extensions-valixdcontrol, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-valixdcontrol, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-valixdcontrol, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-valixdcontrol, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-valixdcontrol, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/ValiXDControl)
	
	@$(call install_finish, enigma2-plugin-extensions-valixdcontrol)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_VIRTUALZAP)  += enigma2-plugin-extensions-virtualzap
ENIGMA2_EXTENSION_VIRTUALZAP_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_VIRTUALZAP_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-virtualzap.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-virtualzap)
	@$(call install_fixup,  enigma2-plugin-extensions-virtualzap, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-virtualzap, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-virtualzap, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-virtualzap, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-virtualzap, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/VirtualZap)
	
	@$(call install_finish, enigma2-plugin-extensions-virtualzap)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_VLCPLAYER)  += enigma2-plugin-extensions-vlcplayer
ENIGMA2_EXTENSION_VLCPLAYER_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_VLCPLAYER_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-vlcplayer.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-vlcplayer)
	@$(call install_fixup,  enigma2-plugin-extensions-vlcplayer, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-vlcplayer, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-vlcplayer, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-vlcplayer, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-vlcplayer, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/VlcPlayer)
	
	@$(call install_finish, enigma2-plugin-extensions-vlcplayer)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_WEATHERPLUGIN)  += enigma2-plugin-extensions-weatherplugin
ENIGMA2_EXTENSION_WEATHERPLUGIN_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_WEATHERPLUGIN_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-weatherplugin.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-weatherplugin)
	@$(call install_fixup,  enigma2-plugin-extensions-weatherplugin, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-weatherplugin, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-weatherplugin, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-weatherplugin, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-weatherplugin, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/WeatherPlugin)
	
	@$(call install_finish, enigma2-plugin-extensions-weatherplugin)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_WEBBOUQUETEDITOR)  += enigma2-plugin-extensions-webbouqueteditor
ENIGMA2_EXTENSION_WEBBOUQUETEDITOR_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_WEBBOUQUETEDITOR_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-webbouqueteditor.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-webbouqueteditor)
	@$(call install_fixup,  enigma2-plugin-extensions-webbouqueteditor, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-webbouqueteditor, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-webbouqueteditor, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-webbouqueteditor, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-webbouqueteditor, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/WebBouquetEditor)
	
	@$(call install_finish, enigma2-plugin-extensions-webbouqueteditor)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_WEBCAMVIEWER)  += enigma2-plugin-extensions-webcamviewer
ENIGMA2_EXTENSION_WEBCAMVIEWER_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_WEBCAMVIEWER_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-webcamviewer.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-webcamviewer)
	@$(call install_fixup,  enigma2-plugin-extensions-webcamviewer, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-webcamviewer, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-webcamviewer, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-webcamviewer, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-webcamviewer, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/WebcamViewer)
	
	@$(call install_finish, enigma2-plugin-extensions-webcamviewer)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_WEBINTERFACE)  += enigma2-plugin-extensions-webinterface
ENIGMA2_EXTENSION_WEBINTERFACE_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_WEBINTERFACE_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-webinterface.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-webinterface)
	@$(call install_fixup,  enigma2-plugin-extensions-webinterface, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-webinterface, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-webinterface, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-webinterface, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-webinterface, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/WebInterface)
	
	@$(call install_finish, enigma2-plugin-extensions-webinterface)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_YOUTUBEPLAYER)  += enigma2-plugin-extensions-youtubeplayer
ENIGMA2_EXTENSION_YOUTUBEPLAYER_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_YOUTUBEPLAYER_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-youtubeplayer.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-youtubeplayer)
	@$(call install_fixup,  enigma2-plugin-extensions-youtubeplayer, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-youtubeplayer, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-youtubeplayer, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-youtubeplayer, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-youtubeplayer, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/YouTubePlayer)
	
	@$(call install_finish, enigma2-plugin-extensions-youtubeplayer)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_YTTRAILER)  += enigma2-plugin-extensions-yttrailer
ENIGMA2_EXTENSION_YTTRAILER_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_YTTRAILER_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-yttrailer.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-yttrailer)
	@$(call install_fixup,  enigma2-plugin-extensions-yttrailer, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-yttrailer, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-yttrailer, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-yttrailer, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-yttrailer, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/YTTrailer)
	
	@$(call install_finish, enigma2-plugin-extensions-yttrailer)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_ZAPHISTORYBROWSER)  += enigma2-plugin-extensions-zaphistorybrowser
ENIGMA2_EXTENSION_ZAPHISTORYBROWSER_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_ZAPHISTORYBROWSER_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-zaphistorybrowser.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-zaphistorybrowser)
	@$(call install_fixup,  enigma2-plugin-extensions-zaphistorybrowser, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-zaphistorybrowser, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-zaphistorybrowser, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-zaphistorybrowser, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-zaphistorybrowser, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/ZapHistoryBrowser)
	
	@$(call install_finish, enigma2-plugin-extensions-zaphistorybrowser)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_ZAPSTATISTIC)  += enigma2-plugin-extensions-zapstatistic
ENIGMA2_EXTENSION_ZAPSTATISTIC_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_ZAPSTATISTIC_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-zapstatistic.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-zapstatistic)
	@$(call install_fixup,  enigma2-plugin-extensions-zapstatistic, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-zapstatistic, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-zapstatistic, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-zapstatistic, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-zapstatistic, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/ZapStatistic)
	
	@$(call install_finish, enigma2-plugin-extensions-zapstatistic)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_ZDFMEDIATHEK)  += enigma2-plugin-extensions-zdfmediathek
ENIGMA2_EXTENSION_ZDFMEDIATHEK_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_ZDFMEDIATHEK_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-zdfmediathek.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-zdfmediathek)
	@$(call install_fixup,  enigma2-plugin-extensions-zdfmediathek, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-zdfmediathek, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-zdfmediathek, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-zdfmediathek, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-zdfmediathek, 0, 0, -, /usr/lib/enigma2/python/Plugins/Extensions/ZDFMediathek)
	
	@$(call install_finish, enigma2-plugin-extensions-zdfmediathek)
	
	@$(call touch)

# ----------------------------------------------------------------------------
# SYSTEMPLUGIN
# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_SYSTEMPLUGIN_AUTOMATICCLEANUP)  += enigma2-plugin-systemplugins-automaticcleanup
ENIGMA2_SYSTEMPLUGIN_AUTOMATICCLEANUP_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_SYSTEMPLUGIN_AUTOMATICCLEANUP_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-systemplugins-automaticcleanup.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-systemplugins-automaticcleanup)
	@$(call install_fixup,  enigma2-plugin-systemplugins-automaticcleanup, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-systemplugins-automaticcleanup, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-systemplugins-automaticcleanup, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-systemplugins-automaticcleanup, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-systemplugins-automaticcleanup, 0, 0, -, /usr/lib/enigma2/python/Plugins/SystemPlugins/AutomaticCleanup)
	
	@$(call install_finish, enigma2-plugin-systemplugins-automaticcleanup)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_SYSTEMPLUGIN_AUTOMATICVOLUMEADJUSTMENT)  += enigma2-plugin-systemplugins-automaticvolumeadjustment
ENIGMA2_SYSTEMPLUGIN_AUTOMATICVOLUMEADJUSTMENT_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_SYSTEMPLUGIN_AUTOMATICVOLUMEADJUSTMENT_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-systemplugins-automaticvolumeadjustment.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-systemplugins-automaticvolumeadjustment)
	@$(call install_fixup,  enigma2-plugin-systemplugins-automaticvolumeadjustment, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-systemplugins-automaticvolumeadjustment, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-systemplugins-automaticvolumeadjustment, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-systemplugins-automaticvolumeadjustment, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-systemplugins-automaticvolumeadjustment, 0, 0, -, /usr/lib/enigma2/python/Plugins/SystemPlugins/AutomaticVolumeAdjustment)
	
	@$(call install_finish, enigma2-plugin-systemplugins-automaticvolumeadjustment)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_SYSTEMPLUGIN_AUTORESOLUTION)  += enigma2-plugin-systemplugins-autoresolution
ENIGMA2_SYSTEMPLUGIN_AUTORESOLUTION_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_SYSTEMPLUGIN_AUTORESOLUTION_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-systemplugins-autoresolution.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-systemplugins-autoresolution)
	@$(call install_fixup,  enigma2-plugin-systemplugins-autoresolution, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-systemplugins-autoresolution, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-systemplugins-autoresolution, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-systemplugins-autoresolution, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-systemplugins-autoresolution, 0, 0, -, /usr/lib/enigma2/python/Plugins/SystemPlugins/AutoResolution)
	
	@$(call install_finish, enigma2-plugin-systemplugins-autoresolution)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_SYSTEMPLUGIN_MPHELP)  += enigma2-plugin-systemplugins-mphelp
ENIGMA2_SYSTEMPLUGIN_MPHELP_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_SYSTEMPLUGIN_MPHELP_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-systemplugins-mphelp.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-systemplugins-mphelp)
	@$(call install_fixup,  enigma2-plugin-systemplugins-mphelp, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-systemplugins-mphelp, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-systemplugins-mphelp, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-systemplugins-mphelp, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-systemplugins-mphelp, 0, 0, -, /usr/lib/enigma2/python/Plugins/SystemPlugins/MPHelp)
	
	@$(call install_finish, enigma2-plugin-systemplugins-mphelp)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_SYSTEMPLUGIN_LIBGISCLUBSKIN)  += enigma2-plugin-systemplugins-libgisclubskin
ENIGMA2_SYSTEMPLUGIN_LIBGISCLUBSKIN_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_SYSTEMPLUGIN_LIBGISCLUBSKIN_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-systemplugins-libgisclubskin.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-systemplugins-libgisclubskin)
	@$(call install_fixup,  enigma2-plugin-systemplugins-libgisclubskin, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-systemplugins-libgisclubskin, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-systemplugins-libgisclubskin, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-systemplugins-libgisclubskin, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-systemplugins-libgisclubskin, 0, 0, -, /usr/lib/enigma2/python/Components/Converter)
	@$(call install_tree,   enigma2-plugin-systemplugins-libgisclubskin, 0, 0, -, /usr/lib/enigma2/python/Components/Renderer)
	
	@$(call install_finish, enigma2-plugin-systemplugins-libgisclubskin)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_SYSTEMPLUGIN_NETWORKBROWSER)  += enigma2-plugin-systemplugins-networkbrowser
ENIGMA2_SYSTEMPLUGIN_NETWORKBROWSER_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_SYSTEMPLUGIN_NETWORKBROWSER_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-systemplugins-networkbrowser.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-systemplugins-networkbrowser)
	@$(call install_fixup,  enigma2-plugin-systemplugins-networkbrowser, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-systemplugins-networkbrowser, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-systemplugins-networkbrowser, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-systemplugins-networkbrowser, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-systemplugins-networkbrowser, 0, 0, -, /usr/lib/enigma2/python/Plugins/SystemPlugins/NetworkBrowser)
	
	@$(call install_finish, enigma2-plugin-systemplugins-networkbrowser)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_SAMBASERVER)  += enigma2-plugin-systemplugins-sambaserver
ENIGMA2_EXTENSION_SAMBASERVER_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_SAMBASERVER_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-sambaserver.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-sambaserver)
	@$(call install_fixup,  enigma2-plugin-extensions-sambaserver, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-sambaserver, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-sambaserver, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-sambaserver, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-sambaserver, 0, 0, -, /usr/lib/enigma2/python/Plugins/SystemPlugins/SambaServer)
	
	@$(call install_finish, enigma2-plugin-extensions-sambaserver)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_STARTUPSERVICE)  += enigma2-plugin-systemplugins-startupservice
ENIGMA2_EXTENSION_STARTUPSERVICE_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_STARTUPSERVICE_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-startupservice.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-startupservice)
	@$(call install_fixup,  enigma2-plugin-extensions-startupservice, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-startupservice, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-startupservice, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-startupservice, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-startupservice, 0, 0, -, /usr/lib/enigma2/python/Plugins/SystemPlugins/StartUpService)
	
	@$(call install_finish, enigma2-plugin-extensions-startupservice)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_SYSTEMPLUGIN_SETPASSWD)  += enigma2-plugin-systemplugins-setpasswd
ENIGMA2_SYSTEMPLUGIN_SETPASSWD_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_SYSTEMPLUGIN_SETPASSWD_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-systemplugins-setpasswd.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-systemplugins-setpasswd)
	@$(call install_fixup,  enigma2-plugin-systemplugins-setpasswd, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-systemplugins-setpasswd, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-systemplugins-setpasswd, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-systemplugins-setpasswd, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-systemplugins-setpasswd, 0, 0, -, /usr/lib/enigma2/python/Plugins/SystemPlugins/SetPasswd)
	
	@$(call install_finish, enigma2-plugin-systemplugins-setpasswd)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_EXTENSION_TOOLKIT)  += enigma2-plugin-systemplugins-toolkit
ENIGMA2_EXTENSION_TOOLKIT_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_EXTENSION_TOOLKIT_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-extensions-toolkit.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-extensions-toolkit)
	@$(call install_fixup,  enigma2-plugin-extensions-toolkit, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-extensions-toolkit, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-extensions-toolkit, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-extensions-toolkit, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-extensions-toolkit, 0, 0, -, /usr/lib/enigma2/python/Plugins/SystemPlugins/Toolkit)
	
	@$(call install_finish, enigma2-plugin-extensions-toolkit)
	
	@$(call touch)

# ----------------------------------------------------------------------------

PACKAGES-$(PTXCONF_ENIGMA2_SYSTEMPLUGIN_VPS)  += enigma2-plugin-systemplugins-vps
ENIGMA2_SYSTEMPLUGIN_VPS_VERSION              := $(ENIGMA2_PLUGINS_SH4_VERSION)
ENIGMA2_SYSTEMPLUGIN_VPS_PKGDIR               := $(ENIGMA2_PLUGINS_SH4_PKGDIR)

$(STATEDIR)/enigma2-plugin-systemplugins-vps.targetinstall:
	@$(call targetinfo)
	
	@$(call install_init,   enigma2-plugin-systemplugins-vps)
	@$(call install_fixup,  enigma2-plugin-systemplugins-vps, PRIORITY,    optional)
	@$(call install_fixup,  enigma2-plugin-systemplugins-vps, SECTION,     base)
	@$(call install_fixup,  enigma2-plugin-systemplugins-vps, AUTHOR,      "Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup,  enigma2-plugin-systemplugins-vps, DESCRIPTION, missing)
	
	@$(call install_tree,   enigma2-plugin-systemplugins-vps, 0, 0, -, /usr/lib/enigma2/python/Plugins/SystemPlugins/vps)
	
	@$(call install_finish, enigma2-plugin-systemplugins-vps)
	
	@$(call touch)

# ----------------------------------------------------------------------------
endif
# vim: syntax=make
