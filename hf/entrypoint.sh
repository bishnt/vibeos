#!/bin/bash
# Runs as a normal user (uid 1000), as Hugging Face Spaces requires.
log() { echo "[vibeos] $*"; }

export HOME=/home/vibe USER=vibe DISPLAY=:1 XDG_RUNTIME_DIR=/tmp/runtime-vibe
mkdir -p "$XDG_RUNTIME_DIR" "$HOME/.vnc"
chmod 700 "$XDG_RUNTIME_DIR"

VNCPASSWD=$(command -v vncpasswd || command -v tigervncpasswd) || { log "ERROR: vncpasswd not found"; exit 1; }
XVNC=$(command -v Xtigervnc || command -v Xvnc) || { log "ERROR: Xtigervnc not found"; exit 1; }

if [ -z "$VNC_PASSWORD" ]; then
  VNC_PASSWORD=$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 8)
  log "No VNC_PASSWORD secret set. Temporary password for this run: $VNC_PASSWORD"
fi
# VNC auth only uses the first 8 characters.
echo "${VNC_PASSWORD:0:8}" | "$VNCPASSWD" -f > "$HOME/.vnc/passwd"
chmod 600 "$HOME/.vnc/passwd"

websockify --web=/usr/share/novnc 6080 127.0.0.1:5901 &
log "web server listening on :6080"

"$XVNC" :1 -geometry 1440x900 -depth 24 -rfbport 5901 \
  -rfbauth "$HOME/.vnc/passwd" -SecurityTypes VncAuth -localhost yes &
for i in $(seq 1 40); do [ -e /tmp/.X11-unix/X1 ] && break; sleep 0.5; done
log "X server ready, launching XFCE"
exec dbus-launch --exit-with-session startxfce4
