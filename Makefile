# Build the Kodi installable add-on archive: creates screensaver.kaster-<version>.zip
# from the add-on tree (addon.xml at the root of the zip, as Kodi expects).
#
# Usage:
#   make build

ZIP ?= zip
ADDON_XML := addon.xml
VERSION := $(shell sed -n 's/.*<addon[^>]*version="\([^"]*\)".*/\1/p' $(ADDON_XML) | head -n1)
ZIPFILE := screensaver.kaster-$(VERSION).zip

# Excluded from the archive: repository data, CI config, build tooling,
# Python bytecode caches, and any previously built zip archives.
ZIP_EXCLUDES := "*/.git" "*/.git/*" ".git/*" "*/.github" "*/.github/*" \
				".github/*" "tools" "tools/*" "*__pycache__*" "*.pyc" "*.zip"

.PHONY: build

build:
	rm -f "$(ZIPFILE)"
	$(ZIP) -qr "$(ZIPFILE)" . -x $(ZIP_EXCLUDES)
