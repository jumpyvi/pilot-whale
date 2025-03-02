FROM ghcr.io/ublue-os/arch-distrobox

RUN useradd -m -s /bin/bash -G wheel adw && echo 'adw:dev' | chpasswd
RUN usermod -aG render,video adw
RUN groupadd docker && usermod -aG docker adw

USER adw

RUN paru -Syyu --noconfirm gtk4 ninja meson libadwaita libgee json-glib desktop-file-utils curl libglvnd vala-language-server fzf just vala docker