# VibeOS in a browser: XFCE desktop served over noVNC on port 6080.
FROM debian:trixie-slim
ENV DEBIAN_FRONTEND=noninteractive LANG=C.UTF-8

COPY config/package-lists/vibeos.list.chroot /tmp/vibeos.list

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      tigervnc-standalone-server tigervnc-common novnc websockify \
      dbus-x11 ca-certificates procps \
 && grep -vE '^\s*(#|$)' /tmp/vibeos.list \
      | grep -vE '^(lightdm|network-manager-gnome)$' \
      | xargs apt-get install -y \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash vibe \
 && rm -f /usr/share/novnc/index.html \
 && printf '<meta http-equiv="refresh" content="0;url=vnc.html?autoconnect=true&resize=scale">' > /usr/share/novnc/index.html

COPY web/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
EXPOSE 6080
ENTRYPOINT ["/entrypoint.sh"]
