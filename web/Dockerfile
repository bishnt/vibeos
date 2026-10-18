# Lean VibeOS desktop for Fly: landing page, calculators and XFCE over noVNC on port 6080.
FROM debian:trixie-slim
ENV DEBIAN_FRONTEND=noninteractive LANG=C.UTF-8

COPY web/lite.list /tmp/lite.list

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      tigervnc-standalone-server tigervnc-common tigervnc-tools novnc websockify \
      x11-xkb-utils xkb-data dbus-x11 ca-certificates procps xauth x11-xserver-utils at-spi2-core \
      librsvg2-common adwaita-icon-theme gsettings-desktop-schemas dconf-gsettings-backend gvfs \
 && grep -vE '^\s*(#|$)' /tmp/lite.list | xargs apt-get install -y --no-install-recommends \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY config/includes.chroot/ /
# the lean image has no Papirus icons
RUN sed -i 's/Papirus-Dark/Adwaita/' /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml

RUN useradd -m -s /bin/bash vibe \
 && mkdir -p /tmp/.X11-unix && chmod 1777 /tmp/.X11-unix \
 && rm -f /usr/share/novnc/index.html

COPY web/landing.html /tmp/landing.html
COPY web/stack-lite.html /tmp/stack.html
COPY web/tools.html /usr/share/novnc/tools.html
COPY web/vibeos.css /usr/share/novnc/vibeos.css
RUN sed -e '/<!--STACK-->/{r /tmp/stack.html' -e 'd}' /tmp/landing.html > /usr/share/novnc/index.html \
 && sed -i 's#<title>.*</title>#<title>VibeOS</title>#; s#</head>#<link rel="stylesheet" href="vibeos.css"></head>#' /usr/share/novnc/vnc.html

COPY web/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
EXPOSE 6080
ENTRYPOINT ["/entrypoint.sh"]
