# -*-makefile-*-
#
# Copyright (C) 2009 by Robert Schwebel
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_OPKG) += opkg

#
# Paths and names
#
OPKG_VERSION	:= 649
OPKG		:= opkg-r$(OPKG_VERSION)
OPKG_URL	:= http://opkg.googlecode.com/svn/trunk/
#http://opkg.googlecode.com/files/$(OPKG).$(OPKG_SUFFIX)
OPKG_SOURCE_SVN	:= $(SRCDIR)/opkg.svn
OPKG_DIR	:= $(BUILDDIR)/$(OPKG)
OPKG_LICENSE	:= GPLv2

$(STATEDIR)/opkg.get:
	@$(call targetinfo)
	
	@$(call shell, ( \
		if [ -d $(OPKG_SOURCE_SVN) ]; then \
			cd $(OPKG_SOURCE_SVN); \
			svn update 2>&1 > /dev/null; \
			cd -; \
		else \
			svn checkout $(OPKG_URL) $(OPKG_SOURCE_SVN) 2>&1 > /dev/null; \
		fi;) 2>&1 > /dev/null)
	
	@$(call shell, ( \
		if [ ! "$(OPKG_VERSION)" == "HEAD" ]; then \
			cd $(OPKG_SOURCE_SVN); \
			svn up -r $(OPKG_VERSION) 2>&1 > /dev/null; \
			cd -; \
		fi;) 2>&1 > /dev/null)
	
	@$(call touch)


$(STATEDIR)/opkg.extract:
	@$(call targetinfo)
	
	@$(call shell, rm -rf $(OPKG_DIR);)
	@$(call shell, cp -a $(OPKG_SOURCE_SVN) $(OPKG_DIR);)
	@$(call shell, rm -rf $(OPKG_DIR)/.git;)
	
	@$(call patchin, OPKG)
	
	cd $(OPKG_DIR) && autoreconf -v --install
	
	@$(call touch)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

OPKG_PATH	:= PATH=$(CROSS_PATH)
OPKG_ENV 	:= $(CROSS_ENV)

#
# autoconf
#
OPKG_CONF_TOOL	:= autoconf
OPKG_CONF_OPT	:= \
	$(CROSS_AUTOCONF_USR) \
	--enable-shave \
	--with-opkglockfile=/var/lock/opkg.lock

ifdef PTXCONF_OPKG_PATHFINDER
OPKG_CONF_OPT += --enable-pathfinder
else
OPKG_CONF_OPT += --disable-pathfinder
endif
ifdef PTXCONF_OPKG_CURL
OPKG_CONF_OPT += --enable-curl
else
OPKG_CONF_OPT += --disable-curl
endif
ifdef PTXCONF_OPKG_SHA256
OPKG_CONF_OPT += --enable-sha256
else
OPKG_CONF_OPT += --disable-sha256
endif
ifdef PTXCONF_OPKG_OPENSSL
OPKG_CONF_OPT += --enable-openssl
else
OPKG_CONF_OPT += --disable-openssl
endif
ifdef PTXCONF_OPKG_SSL_CURL
OPKG_CONF_OPT += --enable-ssl-curl
else
OPKG_CONF_OPT += --disable-ssl-curl
endif
ifdef PTXCONF_OPKG_GPG
OPKG_CONF_OPT += --enable-gpg
else
OPKG_CONF_OPT += --disable-gpg
endif

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/opkg.targetinstall:
	@$(call targetinfo)

	@$(call install_init,  opkg)
	@$(call install_fixup, opkg,PACKAGE,opkg)
	@$(call install_fixup, opkg,PRIORITY,optional)
	@$(call install_fixup, opkg,SECTION,base)
	@$(call install_fixup, opkg,AUTHOR,"Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup, opkg,DESCRIPTION,missing)

ifdef PTXCONF_OPKG_GPG
	@$(call install_copy, opkg, 0, 0, 0755, -, /usr/bin/opkg-key)
endif
#	@$(call install_copy, opkg, 0, 0, 0755, -, /usr/bin/update-alternatives)
	@$(call install_copy, opkg, 0, 0, 0755, $(OPKG_DIR)/src/opkg-cl, /usr/bin/opkg)

	@$(call install_copy, opkg, 0, 0, 0755, -, /usr/share/opkg/intercept/ldconfig)
	@$(call install_copy, opkg, 0, 0, 0755, -, /usr/share/opkg/intercept/depmod)
	@$(call install_copy, opkg, 0, 0, 0755, -, /usr/share/opkg/intercept/update-modules)

	@$(call install_lib,  opkg, 0, 0, 0644, libopkg)

ifdef PTXCONF_IMAGE_IPKG_SIGN_OPENSSL
	@$(call install_copy, opkg, 0, 0, 0644, $(PTXCONF_IMAGE_IPKG_SIGN_OPENSSL_SIGNER), /etc/ssl/certs/opkg.crt)
endif

ifdef PTXCONF_OPKG_OPKG_CONF
	@$(call install_alternative, opkg, 0, 0, 0644, /etc/opkg/opkg.conf)
	@$(call install_replace, opkg, /etc/opkg/opkg.conf, @SRC@, \
		$(PTXCONF_OPKG_OPKG_CONF_URL))
	@$(call install_replace, opkg, /etc/opkg/opkg.conf, @ARCH@, \
		$(PTXDIST_IPKG_ARCH_STRING))
ifdef PTXCONF_OPKG_OPKG_CONF_CHECKSIG
	@$(call install_replace, opkg, /etc/opkg/opkg.conf, @CHECKSIG@, \
		"option check_signature 1")
	@$(call install_replace, opkg, /etc/opkg/opkg.conf, @CAPATH@, \
		"option signature_ca_path /etc/ssl/certs")
	@$(call install_replace, opkg, /etc/opkg/opkg.conf, @CAFILE@, \
		"option signature_ca_file /etc/ssl/certs/opkg.crt")
else
	@$(call install_replace, opkg, /etc/opkg/opkg.conf, @CHECKSIG@, \
		"option check_signature 0")
	@$(call install_replace, opkg, /etc/opkg/opkg.conf, @CAPATH@, \
		"#option signature_ca_path /etc/ssl/certs")
	@$(call install_replace, opkg, /etc/opkg/opkg.conf, @CAFILE@, \
		"#option signature_ca_file /etc/ssl/certs/opkg.crt")
endif
endif

	@$(call install_finish, opkg)

	@$(call touch)

# vim: syntax=make
