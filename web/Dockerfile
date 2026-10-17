# VibeOS in a browser: landing page + XFCE desktop served over noVNC on port 6080.
FROM debian:trixie-slim
ENV DEBIAN_FRONTEND=noninteractive LANG=C.UTF-8

COPY config/package-lists/vibeos.list.chroot /tmp/vibeos.list

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      tigervnc-standalone-server tigervnc-common tigervnc-tools novnc websockify \
      x11-xkb-utils xkb-data fonts-dejavu-core \
      dbus-x11 ca-certificates procps \
 && grep -vE '^\s*(#|$)' /tmp/vibeos.list \
      | grep -vE '^(lightdm|network-manager-gnome)$' \
      | xargs apt-get install -y \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY config/includes.chroot/ /

RUN useradd -m -s /bin/bash vibe \
 && mkdir -p /tmp/.X11-unix && chmod 1777 /tmp/.X11-unix \
 && rm -f /usr/share/novnc/index.html

COPY web/landing.html /usr/share/novnc/index.html
COPY web/vibeos.css /usr/share/novnc/vibeos.css
RUN sed -i 's#<title>.*</title>#<title>VibeOS</title>#; s#</head>#<link rel="stylesheet" href="vibeos.css"></head>#' /usr/share/novnc/vnc.html
COPY web/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
EXPOSE 6080
ENTRYPOINT ["/entrypoint.sh"]
