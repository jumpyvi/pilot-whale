# Gets fedora 41 image
FROM quay.io/fedora/fedora:41

# Adds required developement dependencies
RUN dnf update -y && dnf install fzf just gtk4-devel moby-engine docker-cli ninja-build meson libadwaita-devel dbus-x11 libgee-devel json-glib-devel desktop-file-utils libcurl-devel libglvnd-gles vala-language-server graphviz valadoc valac git vim sudo -y

# Creates the user
RUN useradd -m -s /bin/bash -G wheel adw && echo 'adw:dev' | sudo chpasswd
RUN usermod -aG render,video adw
RUN usermod -aG docker adw

# Allow adw to run sudo commands without a password
RUN echo 'adw ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/adw

# Switch to the user
USER adw

# Adds just completion to ~/.bashrc if they don't already exist
RUN grep -qxF 'source <(just --completions bash)' /home/adw/.bashrc || echo 'source <(just --completions bash)' >> /home/adw/.bashrc