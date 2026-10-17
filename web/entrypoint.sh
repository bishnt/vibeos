#!/bin/bash
set -e
log() { echo "[vibeos] $*"; }

VNCPASSWD=$(command -v vncpasswd || command -v tigervncpasswd) || { log "ERROR: vncpasswd not found"; exit 1; }
XVNC=$(command -v Xtigervnc || command -v Xvnc) || { log "ERROR: Xtigervnc not found"; exit 1; }
log "using $VNCPASSWD and $XVNC"

mkdir -p /tmp/.X11-unix && chmod 1777 /tmp/.X11-unix
install -d -o vibe -g vibe -m 700 /tmp/runtime-vibe

# Start the web server first so the landing page is reachable immediately.
websockify --web=/usr/share/novnc 6080 127.0.0.1:5901 &
log "web server listening on :6080"

if [ -z "$VNC_PASSWORD" ]; then
  VNC_PASSWORD=$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 8)
  log "No VNC_PASSWORD secret set. Temporary password for this boot: $VNC_PASSWORD"
fi
# VNC auth only uses the first 8 characters.
mkdir -p /home/vibe/.vnc
echo "$VNC_PASSWORD" | "$VNCPASSWD" -f > /home/vibe/.vnc/passwd
chmod 600 /home/vibe/.vnc/passwd
chown -R vibe:vibe /home/vibe/.vnc

log "starting desktop"
exec runuser -u vibe -- env HOME=/home/vibe USER=vibe DISPLAY=:1 \
  XDG_RUNTIME_DIR=/tmp/runtime-vibe XVNC="$XVNC" bash -c '
    "$XVNC" :1 -geometry 1440x900 -depth 24 -rfbport 5901 \
      -rfbauth /home/vibe/.vnc/passwd -SecurityTypes VncAuth -localhost yes &
    for i in $(seq 1 40); do [ -e /tmp/.X11-unix/X1 ] && break; sleep 0.5; done
    echo "[vibeos] X server ready, launching XFCE"
    exec dbus-launch --exit-with-session startxfce4
  '
