#!/bin/sh
# Local build. Needs a Debian/Ubuntu host with: sudo apt install live-build
set -e
sudo lb clean --purge || true
sudo lb config
sudo lb build
ls -lh ./*.iso
