# VibeOS for Hugging Face Spaces: runs as non-root uid 1000, noVNC on port 6080.
FROM debian:trixie-slim
ENV DEBIAN_FRONTEND=noninteractive LANG=C.UTF-8

COPY config/package-lists/vibeos.list.chroot /tmp/vibeos.list

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      tigervnc-standalone-server tigervnc-common tigervnc-tools novnc websockify \
      x11-xkb-utils xkb-data fonts-dejavu-core \
      dbus-x11 ca-certificates procps xauth x11-xserver-utils at-spi2-core \
      librsvg2-common adwaita-icon-theme gsettings-desktop-schemas dconf-gsettings-backend gvfs \
      python3-tk kicad-symbols kicad-footprints kicad-templates \
 && grep -vE '^\s*(#|$)' /tmp/vibeos.list \
      | grep -vE '^(lightdm|network-manager-gnome)$' \
      | xargs apt-get install -y --no-install-recommends \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY config/includes.chroot/ /
RUN mkdir -p /usr/lib/firefox-esr/distribution && cp /etc/firefox/policies/policies.json /usr/lib/firefox-esr/distribution/policies.json

RUN useradd -m -u 1000 -s /bin/bash vibe \
 && mkdir -p /tmp/.X11-unix && chmod 1777 /tmp/.X11-unix \
 && rm -f /usr/share/novnc/index.html

COPY web/landing.html /tmp/landing.html
COPY web/stack-full.html /tmp/stack.html
COPY web/tools.html /usr/share/novnc/tools.html
RUN sed -e '/<!--STACK-->/{r /tmp/stack.html' -e 'd}' /tmp/landing.html > /usr/share/novnc/index.html
COPY web/vibeos.css /usr/share/novnc/vibeos.css
RUN sed -i 's#<title>.*</title>#<title>VibeOS</title>#; s#</head>#<link rel="stylesheet" href="vibeos.css"></head>#' /usr/share/novnc/vnc.html

COPY hf/entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh

USER vibe
WORKDIR /home/vibe
EXPOSE 6080
ENTRYPOINT ["/entrypoint.sh"]
