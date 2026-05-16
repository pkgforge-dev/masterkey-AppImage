#!/bin/sh
set -eu
ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
#Make
pacman -S --noconfirm --needed meson blueprint-compiler
#Needed
pacman -S --noconfirm --needed libadwaita python-gobject libpwquality sqlcipher tcl python-pycryptodome python-zxcvbn
#Check
pacman -S --noconfirm --needed appstream-glib desktop-file-utils 

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

echo "Installing masterkey from source packages..."
echo "---------------------------------------------------------------"
git clone https://gitlab.com/guillermop/master-key.git && (
	cd ./master-key
	TAG=$(git tag --sort=-v:refname | grep -vi 'rc\|alpha' | head -1)
	git checkout "$TAG"
	echo "$TAG" > ~/version
	meson setup build --prefix=/usr
	meson compile -C build
	meson install -C build
)

# Comment this out if you need an AUR package
#make-aur-package PACKAGENAME

# If the application needs to be manually built that has to be done down here

# if you also have to make nightly releases check for DEVEL_RELEASE = 1
#
# if [ "${DEVEL_RELEASE-}" = 1 ]; then
# 	nightly build steps
# else
# 	regular build steps
# fi
