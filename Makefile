# Build the Kodi installable add-on archive: creates screensaver.kaster-<version>.zip
#
# Kodi requires the zip to contain the add-on as a single top-level folder
# (CAddonInstaller::InstallFromZip: the archive root must be exactly one
# folder), so the tree is zipped under the add-on directory name.
#
# Usage:
#   make build

ZIP ?= zip
ADDON_XML := addon.xml
ADDON_DIR := $(notdir $(CURDIR))
VERSION := $(shell sed -n 's/.*<addon[^>]*version="\([^"]*\)".*/\1/p' $(ADDON_XML) | head -n1)
ZIPFILE := $(CURDIR)/screensaver.kaster-$(VERSION).zip

# Excluded from the archive: repository data, CI config, build tooling,
# Python bytecode caches, and any previously built zip archives.
ZIP_EXCLUDES := "$(ADDON_DIR)/.git" "$(ADDON_DIR)/.git/*" \
				"$(ADDON_DIR)/.gitignore" "$(ADDON_DIR)/.gitattributes" \
				"$(ADDON_DIR)/.github" "$(ADDON_DIR)/.github/*" \
				"$(ADDON_DIR)/tools" "$(ADDON_DIR)/tools" "$(ADDON_DIR)/tools/*" \
				"$(ADDON_DIR)/Makefile" \
				"$(ADDON_DIR)/*__pycache__*" "$(ADDON_DIR)/*.pyc" "$(ADDON_DIR)/*.zip"

.PHONY: build

build:
	rm -f "$(ZIPFILE)"
	cd "$(dir $(CURDIR))" && \
	$(ZIP) -qr "$(ZIPFILE)" "$(ADDON_DIR)" -x $(ZIP_EXCLUDES)
