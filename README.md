# VibeOS

A Debian trixie-based live distro, built with `live-build` and iterated on with AI.

## Build
- **In CI:** push to `main` (or run the workflow manually). The ISO appears as a build artifact under Actions.
- **Locally (Debian/Ubuntu host):** `./build.sh`

## Test
```
qemu-system-x86_64 -m 4096 -enable-kvm -cdrom live-image-amd64.hybrid.iso
```

## Layout
- `auto/`: live-build config scripts
- `config/package-lists/`: packages included in the image
- `config/includes.chroot/`: files copied into the image root
- `config/hooks/live/`: scripts run inside the image during build
- `CLAUDE.md`: context for AI coding agents

## Use it in a web browser
`web/` packages the same desktop (XFCE + your package list) as a container served through noVNC.

```
cd web
VNC_PASSWORD=choose-one docker compose up --build
# open http://localhost:6080
```
CI publishes the image to `ghcr.io/bishnt/vibeos-web`. To put it online, run that image on any host that supports
Docker and WebSockets (a VPS, Fly.io, Cloud Run) behind HTTPS, with a real password. GitHub Pages can't host it.
