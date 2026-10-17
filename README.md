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

## Host it on Fly.io
1. Install flyctl and run `fly auth login`.
2. `fly apps create bishnt-vibeos` (or change `app` in `fly.toml`).
3. `fly secrets set VNC_PASSWORD=<strong-password> -a bishnt-vibeos`
4. `fly deploy --remote-only` (or add a `FLY_API_TOKEN` repo secret and run the **deploy-fly** workflow).
The machine stops when idle and wakes on the first visit, so the first load takes a few seconds.

## Troubleshooting the hosted desktop
- Set the password: `fly secrets set VNC_PASSWORD=yourpass -a bishnt-vibeos`
- Redeploy after changes: `git pull && fly deploy --remote-only`
- Logs: `fly logs -a bishnt-vibeos` (lines starting with `[vibeos]` show startup progress)
