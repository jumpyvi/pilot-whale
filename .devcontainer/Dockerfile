FROM alpine:3.22

# Install runtime and development dependencies (best-effort mapping from Fedora -> Alpine)
RUN apk update && \
    apk add --no-cache \
    bash sudo fzf just git vim meson ninja build-base pkgconf \
    gtk4.0-dev libadwaita-dev dbus-x11 libgee-dev json-glib-dev \
    desktop-file-utils curl-dev mesa-dev vala vala-doc graphviz \
    docker

# Create the user 'adw', set password, and add to groups
RUN adduser -D -s /bin/bash adw && \
    echo 'adw:dev' | chpasswd && \
    addgroup adw wheel || true && \
    addgroup adw docker || true && \
    addgroup adw video || true && \
    addgroup adw render || true

# Allow adw to run sudo commands without a password
RUN echo 'adw ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/adw && chmod 0440 /etc/sudoers.d/adw

# Switch to the user
USER adw
WORKDIR /home/adw

# Add just completions to ~/.bashrc if they don't already exist
RUN grep -qxF 'source <(just --completions bash)' /home/adw/.bashrc || echo 'source <(just --completions bash)' >> /home/adw/.bashrc