#!/usr/bin/env bash
# shellcheck disable=SC2034

iso_name="code-live"
iso_label="CODE_$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y%m)"
iso_publisher="Code Live (custom Arch Linux profile)"
iso_application="Code Live RAM-only coding environment"
iso_version="$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y.%m.%d)"
install_dir="arch"
bootmodes=('bios.syslinux'
           'uefi.systemd-boot')
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'zstd' '-Xcompression-level' '15' '-b' '1M')
bootstrap_tarball_compression=('zstd' '-c' '-T0' '--auto-threads=logical' '--long' '-19')
kernel_params_aarch64="clk_ignore_unused pd_ignore_unused arm64.nopauth"
# tmpfs limits are ceilings, not preallocated RAM. No persistent COW device.
kernel_params_x86_64="copytoram=y cow_spacesize=50% cow_persistent=N systemd.gpt_auto=no rd.systemd.gpt_auto=no systemd.swap=no noresume"
file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/etc/sudoers.d/10-live"]="0:0:440"
  ["/root"]="0:0:750"
  ["/root/.gnupg"]="0:0:700"
  ["/usr/local/bin/choose-mirror"]="0:0:755"
  ["/usr/local/bin/live-ram-check"]="0:0:755"
  ["/usr/local/bin/live-wallpaper-apply"]="0:0:755"
)
