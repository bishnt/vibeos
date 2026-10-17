#!/bin/bash
# The web server stays up even if the desktop fails, and startup output is
# written to /status.txt so problems can be read from a browser.
STATUS=/usr/share/novnc/status.txt
: > "$STATUS"; chmod 644 "$STATUS"
tail -F "$STATUS" &
log() { echo "[vibeos] $*" >> "$STATUS"; }

websockify --web=/usr/share/novnc 6080 127.0.0.1:5901 >> "$STATUS" 2>&1 &
WS=$!
log "web server started on :6080 (pid $WS)"
log "memory: $(free -m | awk '/Mem/{print $2}') MB"

start_desktop() {
  set -e
  VNCPASSWD=$(command -v vncpasswd || command -v tigervncpasswd)
  XVNC=$(command -v Xtigervnc || command -v Xvnc)
  log "vncpasswd=$VNCPASSWD xvnc=$XVNC"

  mkdir -p /tmp/.X11-unix && chmod 1777 /tmp/.X11-unix
  install -d -o vibe -g vibe -m 700 /tmp/runtime-vibe

  if [ -z "$VNC_PASSWORD" ]; then
    VNC_PASSWORD=$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 8)
    log "No VNC_PASSWORD secret set. A temporary password was printed to the Fly logs."
    echo "[vibeos] temporary password: $VNC_PASSWORD" > /proc/1/fd/1
  fi
  # VNC auth only uses the first 8 characters.
  mkdir -p /home/vibe/.vnc
  echo "${VNC_PASSWORD:0:8}" | "$VNCPASSWD" -f > /home/vibe/.vnc/passwd
  chmod 600 /home/vibe/.vnc/passwd
  chown -R vibe:vibe /home/vibe/.vnc
  log "password file written"

  log "starting X server and XFCE"
  runuser -u vibe -- env HOME=/home/vibe USER=vibe DISPLAY=:1 \
    XDG_RUNTIME_DIR=/tmp/runtime-vibe XVNC="$XVNC" bash -c '
      "$XVNC" :1 -geometry 1440x900 -depth 24 -rfbport 5901 \
        -rfbauth /home/vibe/.vnc/passwd -SecurityTypes VncAuth -localhost yes &
      for i in $(seq 1 40); do [ -e /tmp/.X11-unix/X1 ] && break; sleep 0.5; done
      echo "[vibeos] X server socket ready: $(ls /tmp/.X11-unix)"
      exec dbus-launch --exit-with-session startxfce4
    '
}

( start_desktop ) >> "$STATUS" 2>&1
log "desktop exited with code $?. Keeping the web server up so this log stays readable."
wait $WS
