# Code Live

Custom Archiso profile for a disposable Niri coding session.
Target: x86_64, Intel integrated graphics, 16 GiB RAM, USB 3.

## Current setup

- `live` (UID/GID 1000) automatically logs in on tty1 and starts `niri-session`.
- Fish is the user's login shell; Foot inherits it.
- Both root and live have locked passwords. Automatic local login works via
  agetty; `sudo` does not require a password. Set a temporary password with
  `sudo passwd live` before using a password-based screen locker.
- SSH client is installed, but the SSH server is not enabled. The original
  installer configuration allowing root SSH password login has been removed.
- NetworkManager handles Ethernet/Wi-Fi; use `nmtui` to configure connections.
  systemd-resolved provides DNS. systemd-networkd and standalone iwd are not enabled.
- Home directory configs are embedded under `airootfs/home/live/`.
  mkarchiso sets their ownership from `airootfs/etc/passwd` during the build.
- No persistence is configured. Session changes are lost on shutdown.

This is an intentionally open local live session, not a secure multi-user system.
Do not put tokens, private SSH keys or Wi-Fi passwords into the profile.

## Keyboard shortcuts

`Mod` is the Windows/Super key.

| Shortcut | Action |
| --- | --- |
| Mod+Enter | Foot |
| Mod+D | Application launcher |
| Mod+E | Zed (`zeditor` on Arch) |
| Mod+B | Firefox |
| Mod+N | Network setup (`nmtui`) |
| Alt+Shift | English/Russian layout |
| Mod+arrows | Focus windows/columns |
| Mod+Shift+arrows | Move windows/columns |
| Mod+PageUp/PageDown | Change workspace |
| Mod+R | Cycle column widths |
| Mod+F / Mod+Shift+F | Maximize column / fullscreen |
| Mod+V | Toggle floating |
| Mod+Q | Close window |
| Print | Screenshot |
| Mod+Shift+/ | Shortcut help |
| Mod+Shift+E | Exit Niri (autologin starts a new session) |

## Still to configure before building

- RAM-copy boot parameters (`copytoram=y`) and cleanup of installer boot entries.
- Zed settings and local C/C++ language-server setup.
- ISO build and boot tests (UEFI/BIOS, networking, graphics, sound, offline use).

The current profile has not yet been built or boot-tested. RAM-only operation
and safe USB removal must be verified on the resulting image before relying on them.
