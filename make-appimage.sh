#!/bin/sh
set -eu

# Setup
ARCH=$(uname -m)
export ARCH
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/icons/hicolor/scalable/apps/com.gitlab.guillermop.MasterKey.svg
export DESKTOP=/usr/share/applications/com.gitlab.guillermop.MasterKey.desktop
export PATH_MAPPING='/usr/share/master-key:${SHARUN_DIR}/share/master-key'
export DEPLOY_PYTHON=1
export STARTUPWMCLASS=com.gitlab.guillermop.MasterKey # Default to Wayland's wmclass. For X11, GTK_CLASS_FIX will force the wmclass to be the Wayland one.
export GTK_CLASS_FIX=1
export ALWAYS_SOFTWARE=1

# Deploy dependencies
quick-sharun \
	/usr/bin/master-key       \
	/usr/share/master-key     \
	/usr/lib/libpwquality.so* \
	/usr/lib/libtcl8.6.so*    \
	/usr/lib/libsqlcipher.so* \
	/usr/lib/libgtk-4.so*

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --test ./dist/*.AppImage
