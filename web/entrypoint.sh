#!/bin/bash
set -e
if [ -z "$VNC_PASSWORD" ]; then
  VNC_PASSWORD=$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 8)
  echo "No VNC_PASSWORD set. Generated password: $VNC_PASSWORD"
fi
# VNC auth only uses the first 8 characters.
mkdir -p /home/vibe/.vnc
echo "$VNC_PASSWORD" | vncpasswd -f > /home/vibe/.vnc/passwd
chmod 600 /home/vibe/.vnc/passwd
chown -R vibe:vibe /home/vibe/.vnc

websockify --web=/usr/share/novnc 6080 localhost:5901 &

exec runuser -l vibe -c '
  export DISPLAY=:1
  Xtigervnc :1 -geometry 1440x900 -depth 24 -rfbport 5901 \
    -rfbauth /home/vibe/.vnc/passwd -SecurityTypes VncAuth -localhost yes &
  sleep 2
  exec dbus-launch --exit-with-session startxfce4
'
