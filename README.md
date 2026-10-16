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
- Boot entries copy the compressed root image to RAM (`copytoram=y`). The
  writable overlay is tmpfs, limited to 50% of RAM (not reserved in advance).
- GPT partition automount and hibernation-resume generators are masked. Disk
  swap is disabled via the kernel command line and a masked `swap.target`.
  `fstab` and `crypttab` contain no device entries. This does not prevent manual
  access to internal disks using administrator privileges.
- SquashFS and initramfs use Zstandard for faster decompression. Network/PXE
  boot and screen-reader boot entries are not included in this profile.

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

## RAM-only boot verification

After booting the ISO, run:

```sh
sudo live-ram-check
free -h
```

The read-only check verifies that the SquashFS backing file is under the RAM
mount, the overlay is on tmpfs, the Archiso boot-media mounts are gone, and no
swap is active. It then lists devices so you can inspect any other mounts.
Do not pull the USB out during boot/copying or while any partition on it is
still mounted. Test USB removal only after these checks pass.

The compressed image, writable changes and applications all share physical
RAM. tmpfs limits do not reserve memory or prevent out-of-memory conditions.
There is deliberately no disk-swap fallback: avoid large builds/downloads.
The overlay limit includes projects and browser/editor caches, not just configs.

## Still to configure before building

- Zed settings and local C/C++ language-server setup.
- ISO build and boot tests (UEFI/BIOS, networking, graphics, sound, offline use).

The current profile has not yet been built or boot-tested. RAM-only operation
and safe USB removal must be verified on the resulting image before relying on them.
