#!/bin/sh
# Overlay the Klipper parts of a FlashForge Creator 5 Pro update package onto
# this checkout so that `git diff` shows what FlashForge changed.
#
#   git checkout ff-stock
#   ./ff-import.sh /path/to/software-1.9.9        # extracted package dir
#   git diff --stat; git diff                      # review
#   git commit -a -m "ff: import software-1.9.9"; git tag ff-1.9.9
#
# Layout of the package (see its run.sh): klipper/klippy/* -> klippy/,
# klipper/kinematics/* -> klippy/kinematics/, klipper/extras/* -> klippy/extras/,
# klipper/chelper.tar -> klippy/chelper/ (prebuilt c_helper.so, not tracked),
# klipper/config/* -> /usr/data/config/ (tracked here as ff-config/).
set -e
PKG=${1:?usage: $0 <extracted software-x.y.z dir>}
cd "$(dirname "$0")"
cp -f "$PKG"/klipper/klippy/*    klippy/
cp -f "$PKG"/klipper/kinematics/* klippy/kinematics/
cp -f "$PKG"/klipper/extras/*    klippy/extras/
cp -f "$PKG"/klipper/config/*    ff-config/
for f in klipper_pri.sh start.sh; do [ -f "$PKG/$f" ] && cp -f "$PKG/$f" .; done
git status --short
