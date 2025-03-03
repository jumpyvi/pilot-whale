# Gets base image from ublue (has paru, xdg and base-devel preinstalled)
FROM ghcr.io/ublue-os/arch-distrobox

# Add the "adw" user as a root user with the video, render and docker group
RUN useradd -m -s /bin/bash -G wheel adw && echo 'adw:dev' | chpasswd
RUN usermod -aG render,video adw
RUN groupadd docker && usermod -aG docker adw

# Switch to the "adw" user
USER adw

# Add developement dependencies
RUN paru -Syyu --noconfirm gtk4 ninja meson libadwaita libgee json-glib desktop-file-utils curl libglvnd vala-language-server fzf just vala docker