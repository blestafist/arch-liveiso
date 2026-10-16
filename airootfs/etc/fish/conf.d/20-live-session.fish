# Only the automatic, interactive login on tty1 starts the desktop.
# niri-session also invokes a non-interactive login shell: do not recurse.
if status is-interactive; and status is-login
    if test (id -un) = live; and test (tty) = /dev/tty1
        if not set -q WAYLAND_DISPLAY; and not set -q DISPLAY
            exec niri-session
        end
    end
end
