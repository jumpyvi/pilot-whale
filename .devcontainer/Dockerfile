FROM quay.io/fedora/fedora:41

RUN dnf update -y && dnf install gtk4-devel ninja-build meson libadwaita-devel dbus-x11 libgee-devel json-glib-devel desktop-file-utils libcurl-devel libglvnd-gles vala-language-server valac git vim -y

RUN dnf install -y dnf-plugins-core && \
    dnf-3 config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo && \
    dnf install -y docker-ce docker-ce-cli containerd.io

RUN useradd -m -s /bin/bash -G wheel dev && echo 'dev:dev' | sudo chpasswd
RUN usermod -aG render,video dev
RUN usermod -aG docker dev

USER dev