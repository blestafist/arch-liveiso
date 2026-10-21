# Code Live

Custom Archiso profile for a disposable Niri coding session.
Target: x86_64, Intel integrated graphics, 16 GiB RAM, USB 3.

## Current setup

- `live` (UID/GID 1000) automatically logs in on tty1 and starts `niri-session`.
- Fish is the user's login shell; Foot inherits it.
- Fish includes the source PC's `runc` function: select a `.cpp` file (or pass
  its name), compile with `clang++ -std=c++17 -Wall -Wextra -O3`, then run
  `output.bin`. The executable is created in the current directory.
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
| Mod+T | Foot |
| Mod+E | Thunar file manager |
| Mod+R | Fuzzel application launcher |
| Mod+Space / Mod+Shift+Space | Polish/Russian layout, next/previous (Caps Lock acts as Ctrl) |
| Mod+arrows | Focus windows/columns |
| Mod+Ctrl+arrows | Move windows/columns |
| Mod+Shift+arrows | Focus monitor |
| Mod+PageUp/PageDown | Change workspace |
| Mod+X | Cycle column widths |
| Mod+F / Mod+Shift+F | Maximize column / fullscreen |
| Mod+V | Toggle floating |
| Mod+Q | Close window |
| Print | Screenshot |
| Mod+Shift+/ | Shortcut help |
| Mod+Shift+E | Exit Niri (autologin starts a new session) |

## Desktop appearance

- Thunar is the default handler for folders, with GVfs for file operations and
  manual mounting. No thunar-volman or removable-drive automount is configured.
- GTK 3/4 settings match the source PC: Catppuccin Mocha Rosewater
  (`catppuccin-mocha-rosewater-standard+default`), Adwaita icons/cursor and
  Adwaita Sans 11. The local theme is bundled for offline use; no global
  `GTK_THEME` override is forced on applications. Libadwaita applications may
  keep their own appearance. Thunar appearance still needs ISO boot testing.
- Niri uses the current local config: 6px gaps, 3px amber/red borders,
  default animations, PL/RU layouts and the source PC's keybindings.
  The example output block remains disabled, so outputs are detected automatically.
  Waybar is removed, including its package, config and startup command.
  Only startup is adapted: wallpaper uses the live service, and PipeWire /
  WirePlumber use their packaged systemd user units rather than duplicate processes.
- Fuzzel is copied unchanged from the local PC: translucent Catppuccin Mocha,
  rounded corners and JetBrains Mono. Config:
  `airootfs/home/live/.config/fuzzel/fuzzel.ini`.
- `awww` replaces swaybg. The source PC's current `frieren-snow.png` is bundled
  under `/usr/share/backgrounds/code-live/`. Niri starts the user service
  `live-wallpaper.service`; its startup helper waits for an output before
  applying the image to all current outputs, cropped to fill, without animation.
  The daemon is stopped with the graphical session. No host wallpaper cache
  is copied. Display hotplug and appearance still need testing in the ISO.
- The host's desktop settings and currently displayed wallpaper are untouched.
- Foot, Fastfetch (`terminal-open`), btop, pavucontrol and Zed settings are copied
  unchanged from the local PC. Fish retains all local aliases and the Fastfetch
  startup, plus the existing `runc` function. Its tty1 startup is handled by the
  existing system-wide live-session hook instead of the host's D-Bus command.
  Neovim and brightnessctl are included for the local aliases and keybindings.
  Fish history, browser profiles, credentials and application caches are not copied.

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

- ISO build and boot tests (UEFI/BIOS, networking, graphics, sound, offline use).

The current profile has not yet been built or boot-tested. RAM-only operation
and safe USB removal must be verified on the resulting image before relying on them.

## Firefox

Firefox starts with a clean profile. An allowlist of local preferences is applied
as editable defaults through `airootfs/etc/firefox/policies/policies.json`:
hidden bookmarks toolbar, local sidebar settings, no trending search suggestions,
no password-save prompts, Global Privacy Control, the local content-blocking
category and no Russian translation prompts.

uBlock Origin 1.75.0 and the local Saffox Dark theme 1.2 are bundled as unmodified
XPIs under `/usr/share/code-live/firefox/extensions/`. Policies install them from
local files on first launch, without needing an internet download; they can be
disabled in the add-ons manager. The active-theme default points to Saffox Dark.
Normal extension and filter updates may still use the network.

No entire Firefox profile is copied: passwords, cookies, history, bookmarks,
open tabs, Sync/account state, search databases, site permissions, extension
storage and custom uBlock rules are excluded. Dark Reader and Proton Pass are
not bundled. This is not a byte-for-byte copy of the local Firefox profile.
First-run installation, theme activation and policy behavior still need testing
in the built ISO (`about:policies`, `about:addons`). Add-on sources and checksums
are documented in `airootfs/usr/share/code-live/firefox/README.md`.

## Zed

Settings are copied unchanged from the source PC's `~/.config/zed/settings.json`:
Gruvbox Dark, default icons, UI size 16, editor size 15, left project panel,
autosave after 800 ms and disabled telemetry. As on the source PC,
`trust_all_worktrees` is enabled: only open projects you trust.
The previous live-specific AI, update and language-server overrides are no longer
applied; language servers or extensions may require downloads.
No authentication, account state, editor history or host projects are copied.

These previously bundled, data-only extensions remain available under
  `airootfs/home/live/.local/share/zed/extensions/installed/`:

| Extension | Version | Upstream |
| --- | --- | --- |
| Claude Code Inspired Dark | 1.0.0 | https://github.com/ericbuess/claude-code-inspired-dark |
| Charmed Icons | 0.10.0 | https://github.com/jmesrje/zed-charmed-icons |
| Monokai Night Theme | 0.2.2 | https://github.com/farbodvand/zed-monokai-night |

The host's Zed configuration is not changed.

For CMake projects, generate a compilation database with:

```sh
cmake -S . -B build -G Ninja -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
cmake --build build -j2
```

## First ISO build

Use an Arch Linux build host (an Arch VM is recommended when the host is Artix),
with the `archiso` package installed. The source PC runs Artix and currently has
no `mkarchiso`; do not mix Arch packages into the Artix host to build this profile.
The profile's `pacman.conf` includes `/etc/pacman.d/mirrorlist` from the build
environment, which must contain Arch mirrors, not Artix mirrors.

Run from the profile directory on the Arch build host:

```sh
sudo mkarchiso -v -w work/build-01 -o out .
```

This installs packages into the build tree, not the host root filesystem.
Packages require an internet connection during the build; allow tens of GiB
of disk space for the working tree and package cache. The ISO is written to
`out/`. This command does not write to or format a USB drive.

If the profile changes after a build attempt, use a fresh work subdirectory
(for example `work/build-02`), because mkarchiso caches completed steps.
The resulting ISO is unsigned: normal UEFI boot requires Secure Boot to be
disabled with the computer owner's permission, unless signing is set up separately.
