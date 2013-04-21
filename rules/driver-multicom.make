# -*-makefile-*-
#
# Copyright (C) @YEAR@ by @AUTHOR@
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_DRIVER_MULTICOM) += driver-multicom

#
# Paths and names and versions
#

ifdef PTXCONF_DRIVER_MULTICOM_V3
DRIVER_MULTICOM_MAJORVERSION	:= 3
DRIVER_MULTICOM_MINORVERSION	:= 2
DRIVER_MULTICOM_MICROVERSION	:= 4
DRIVER_MULTICOM_MD5	:= 27d45129f5bf4edcc440252eadcc0d99
endif

ifdef PTXCONF_DRIVER_MULTICOM_V4
DRIVER_MULTICOM_MAJORVERSION	:= 4
DRIVER_MULTICOM_MINORVERSION	:= 0
DRIVER_MULTICOM_MICROVERSION	:= 6
DRIVER_MULTICOM_MD5	:= 7f262e7e01046be8fc5595c3cd37a74a
endif

DRIVER_MULTICOM_VERSION	:= $(DRIVER_MULTICOM_MAJORVERSION).$(DRIVER_MULTICOM_MINORVERSION).$(DRIVER_MULTICOM_MICROVERSION)
DRIVER_MULTICOM_SHORTVERSION	:= $(DRIVER_MULTICOM_MAJORVERSION)$(DRIVER_MULTICOM_MINORVERSION)$(DRIVER_MULTICOM_MICROVERSION)
DRIVER_MULTICOM		:= multicom-$(DRIVER_MULTICOM_VERSION)
DRIVER_MULTICOM_SUFFIX		:= tar.gz
DRIVER_MULTICOM_URL		:= ftp://sts-tools:sts-tools@ftp.st.com/products/multicom$(DRIVER_MULTICOM_MAJORVERSION)/R$(DRIVER_MULTICOM_VERSION)/stm-multicom.$(DRIVER_MULTICOM_SHORTVERSION)-$(DRIVER_MULTICOM_VERSION)-noarch.$(DRIVER_MULTICOM_SUFFIX)
DRIVER_MULTICOM_SOURCE	:= $(SRCDIR)/stm-multicom.$(DRIVER_MULTICOM_SHORTVERSION)-$(DRIVER_MULTICOM_VERSION)-noarch.$(DRIVER_MULTICOM_SUFFIX)
DRIVER_MULTICOM_DIR		:= $(BUILDDIR)/$(DRIVER_MULTICOM)
DRIVER_MULTICOM_LICENSE	:= unknown

ifdef PTXCONF_DRIVER_MULTICOM
$(STATEDIR)/kernel.targetinstall.post: $(STATEDIR)/driver-multicom.targetinstall
endif

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

$(STATEDIR)/driver-multicom.prepare: $(STATEDIR)/driver-multicom.extract
	@$(call targetinfo)
	
ifdef PTXCONF_DRIVER_MULTICOM_V3
	chmod 644 $(DRIVER_MULTICOM_DIR)/include/mme.h
	#chmod 644 $(DRIVER_MULTICOM_DIR)/linux/source/include/mme/*.h
endif
	
ifdef PTXCONF_DRIVER_MULTICOM_V4
	chmod 644 $(DRIVER_MULTICOM_DIR)/linux/source/include/mme.h
	chmod 644 $(DRIVER_MULTICOM_DIR)/linux/source/include/mme/*.h
endif
	
	@$(call touch)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

$(STATEDIR)/driver-multicom.compile: $(STATEDIR)/driver-multicom.prepare
	@$(call targetinfo)
	
ifdef PTXCONF_DRIVER_MULTICOM_V3
	cd $(DRIVER_MULTICOM_DIR) && \
		$(MAKE) \
		ARCH=sh CROSS_COMPILE=sh4-linux- \
		KERNELDIR=$(KERNEL_DIR) \
		O=$(KERNEL_DIR) \
		modules
	
	#cd $(DRIVER_MULTICOM_DIR) && \
	#	$(MAKE) -f makefile $(CROSS_ENV_CC) \
	#	KBUILD_WRAPPER=1 \
	#	KERNELDIR=$(KERNEL_DIR) \
	#	KERNELDIR_ST40_LINUX_KO=$(KERNEL_DIR) \
	#	DISABLE_IA32_LINUX=0 \
	#	DISABLE_ST40_OS21=0 \
	#	DISABLE_ST40_LINUX=1 \
	#	DISABLE_ST40_WINCE=0 \
	#	DISABLE_ST231_OS21=0 \
	#	DISABLE_PLATFORM_WARNINGS=1 \
	#	install
endif
	
ifdef PTXCONF_DRIVER_MULTICOM_V4
	cd $(KERNEL_DIR) && $(KERNEL_PATH) $(KERNEL_ENV) \
		$(MAKE) $(KERNEL_MAKEVARS) \
		-C $(KERNEL_DIR) \
		M=$(DRIVER_MULTICOM_DIR)/linux/source \
		INSTALL_MOD_PATH=$(DRIVER_MULTICOM_PKGDIR) \
		modules
	
	cd $(DRIVER_MULTICOM_DIR)/linux/source && \
		$(MAKE) $(CROSS_ENV_CC) -f Makefile.linux
endif
	
	@$(call touch)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

$(STATEDIR)/driver-multicom.install: $(STATEDIR)/driver-multicom.compile
	@$(call targetinfo)
	mkdir -p $(DRIVER_MULTICOM_PKGDIR)
ifdef PTXCONF_DRIVER_MULTICOM_V3
	cd $(DRIVER_MULTICOM_DIR) && \
		$(MAKE) \
		ARCH=sh CROSS_COMPILE=sh4-linux- \
		KERNELDIR=$(KERNEL_DIR) \
		INSTALL_MOD_PATH=$(DRIVER_MULTICOM_PKGDIR) \
		modules_install
	
	cd $(DRIVER_MULTICOM_DIR) && \
		$(MAKE) -f makefile $(CROSS_ENV_CC) \
		install
	
	mkdir -p $(DRIVER_MULTICOM_PKGDIR)/usr/lib
	cp $(DRIVER_MULTICOM_DIR)/lib/linux/st40/*.so $(DRIVER_MULTICOM_PKGDIR)/usr/lib/
	
	mkdir -p $(DRIVER_MULTICOM_PKGDIR)/usr/include
	cp $(DRIVER_MULTICOM_DIR)/include/mme.h $(DRIVER_MULTICOM_PKGDIR)/usr/include/
	#cp -r $(DRIVER_MULTICOM_DIR)/linux/source/include/mme $(DRIVER_MULTICOM_PKGDIR)/usr/include/
	
	cp -r $(DRIVER_MULTICOM_PKGDIR)/* $(SYSROOT)
endif
	
ifdef PTXCONF_DRIVER_MULTICOM_V4
	cd $(KERNEL_DIR) && $(KERNEL_PATH) $(KERNEL_ENV) \
		$(MAKE) $(KERNEL_MAKEVARS) \
		-C $(KERNEL_DIR) \
		M=$(DRIVER_MULTICOM_DIR)/linux/source \
		INSTALL_MOD_PATH=$(DRIVER_MULTICOM_PKGDIR) \
		modules_install
	
	mkdir -p $(SYSROOT)/usr/lib
	cp $(DRIVER_MULTICOM_DIR)/linux/source/lib/linux/st40/sh4-linux-/*.so $(SYSROOT)/usr/lib/
	
	mkdir -p $(SYSROOT)/usr/include
	cp $(DRIVER_MULTICOM_DIR)/linux/source/include/mme.h $(SYSROOT)/usr/include/
	cp -r $(DRIVER_MULTICOM_DIR)/linux/source/include/mme $(SYSROOT)/usr/include/
endif
	
	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/driver-multicom.targetinstall:
	@$(call targetinfo)

	@$(call install_init,  driver-multicom)
	@$(call install_fixup, driver-multicom, PRIORITY,optional)
	@$(call install_fixup, driver-multicom, SECTION,base)
	@$(call install_fixup, driver-multicom, AUTHOR,"Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup, driver-multicom, DESCRIPTION,missing)

	@cd $(DRIVER_MULTICOM_PKGDIR) && \
		find lib -type f -name "*.ko" | while read file; do \
			$(call install_copy, driver-multicom, 0, 0, 0644, $(DRIVER_MULTICOM_PKGDIR)/$${file}, /lib/modules/`basename $${file}`, k) \
	done

	@$(call install_lib, zlib, 0, 0, 0644, libmme_host)

	@$(call install_finish, driver-multicom)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

#$(STATEDIR)/driver-multicom.clean:
#	@$(call targetinfo)
#	@$(call clean_pkg, DRIVER_MULTICOM)

# vim: syntax=make
