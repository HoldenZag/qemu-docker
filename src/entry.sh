#!/usr/bin/env bash
set -Eeuo pipefail

echo "❯ Starting QEMU for Docker v$(</run/version)..."
echo "❯ For support visit https://github.com/qemus/qemu-docker/"

cd /run

. reset.sh      # Initialize system
. install.sh    # Get bootdisk
. disk.sh       # Initialize disks
. display.sh    # Initialize graphics
. network.sh    # Initialize network
. boot.sh       # Configure boot
. proc.sh       # Initialize processor
. config.sh     # Configure arguments

trap - ERR

if [[ "${DISPLAY,,}" == "vnc" ]]; then
  websockify -D --web /usr/share/novnc/ 8006 localhost:5900
fi

info "Booting image using $VERS..."

[[ "$DEBUG" == [Yy1]* ]] && set -x
exec qemu-system-x86_64 ${ARGS:+ $ARGS}
