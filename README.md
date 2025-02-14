# Whaler GTK4

<div align="center">
 <img src="data/images/logo/64.png" alt="Whaler"/>
</div>

<p style="text-align:center;">Manage your container, Adwaita style</p>

![List of Docker containers](data/images/screenshots/screenshot-1.png?raw=true)

## Description

### Fork disclamers

This is a fork of [Whaler by sdv43](https://github.com/sdv43/whaler). This fork ports that project to GTK4 and libadwaita and adds some features.

### About

Whaler provides basic functionality for managing Docker containers. The app can start and stop both standalone containers and docker-compose applications. Also, it supports container logs viewing.

The solution is perfect for those who are looking for a simple tool to perform some basic actions. For the app to run correctly, make sure that Docker is installed on your system.

## Installation

Not yet available, see [building](#building) for now.

## Usage with Podman

1. Open Whaler
2. An error-screen should appear
3. Click on the hamburger menu -> Preferences
4. Replace the `API socket path` with something like `/run/user/1000/podman/podman.sock`

## Development

Development can be done in a devcontainer. All dependencies are already present. Tasks and extensions are pre-configured for VSCode.

1. Get VSCode, Docker and the devcontainer VSCode extension
2. Set permission to /var/run/docker.sock to ``1000:docker``
3. Create an empty folder ``~/.Xauthority``
4. Open the project and run ``Dev Containers : Rebuild Container``

## Building

You'll need the following dependencies:
* gio-2.0
* gtk4-devel
* libgee-devel
* gdk-pixbuf-2.0
* json-glib-devel
* libcurl
* libadwaita-1
* posix
* meson
* ninja
* valac

### Meson

In project root:
```
meson build --prefix=/usr
cd build
ninja

sudo ninja install
./build/src/com.github.sdv43.whaler
```

### Flatpak

Not yet available

## License
This project is licensed under the GPL-3.0 License - see the [LICENSE](LICENSE) file for details.