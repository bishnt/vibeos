# VibeOS: agent context

Goal: a lightweight Debian trixie-based live distro for engineering students
(XFCE, KiCad, Python/ML tools). Built with Debian `live-build`.

Rules for the coding agent:
- Only use package names that exist in Debian trixie. Verify with `apt-cache policy <pkg>` before adding.
- Config lives in `auto/config` and `config/`. Do not hand-edit generated dirs (chroot/, binary/, cache/).
- Every change must be testable by building the ISO and booting it in QEMU/VirtualBox.
- When a build fails, read `build.log`, fix the root cause, don't suppress the error.

Roadmap:
1. Bootable live ISO (this scaffold)
2. Branding (wallpaper, GRUB theme, os-release)
3. Calamares installer
4. Custom apt repo + preinstalled ML/edge tooling
