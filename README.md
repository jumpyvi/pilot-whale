# Pilot Whale container manager

<div align="center">
 <img src="data/images/logo/64.png" alt="pilot-whale"/>
 <p><b>Pilot your docker containers.</b></p>
 <p><i>A fork of Whaler</i></p>
</div>


![List of Docker containers](data/images/screenshots/screenshot-1.png?raw=true)

## Description

### 👥 Fork disclamers

This is a fork of [Whaler by sdv43](https://github.com/sdv43/whaler). This fork ports that project to GTK4 and libadwaita and adds some features.

### 💫 About

Pilot Whale provides basic functionality for managing Docker containers. The app can start and stop both standalone containers and docker-compose applications. Also, it supports container logs viewing.

It can also search images from DockerHub and pull images from anywhere.

The solution is perfect for those who are looking for a simple tool to perform some basic actions. For the app to run correctly, make sure that Docker is installed on your system.

## 📦 Installation

This app is only officially packaged for Flatpak, you can download the latest flatpak package in the [releases](https://github.com/jumpyvi/pilot-whale/releases).

To install it, simply do:

```bash
flatpak install pilot-whale-VERSION-ARCH.flatpak
```

> This app has access to your Docker and Podman sockets by default

## 🚢 Usage with Podman

1. Open Pilot Whale
2. An error could appear (docker not detected), ignore it
3. Click on the hamburger menu -> Preferences
4. Replace the `API socket path` with something like `/run/user/1000/podman/podman.sock`

## 🛠️ Development

Development should be done in a devcontainer. <br>
All dependencies are already present in the devcontainer.


### Before setting up your IDE
* The socket at ``/var/run/docker.sock`` must have its permissions set to ``1000:docker``.

* You also need to enable xhost local connection with ``xhost +local:docker``

* To be able to test hyperlink in the app you can run ``just install-test-browser`` in the devcontainer

### For VSCode
1. Get VSCode, Docker and the devcontainer VSCode extension
2. Open the project and run ``Dev Containers : Rebuild Container``
3. You can launch premade tasks from the VSCode task menu, this includes tasks for build and running the app.

### For vim
1. Get devcontainer-cli from [linuxbrew](), [nixpkgs](https://search.nixos.org/packages?channel=24.11&show=devcontainer&from=0&size=50&sort=relevance&type=packages&query=devcontainer) or [npm](https://github.com/devcontainers/cli?tab=readme-ov-file#npm-install)
2. If you want to use your own VIM config uncomment ``Mounts for VIM config file`` in [devcontainer.json](.devcontainer/devcontainer.json)
3. From the project root run:
```bash
devcontainer up --workspace-folder $(pwd) && devcontainer exec --workspace-folder $(pwd) bash
```
4. You can now run vim or install another editor
5. You can launch premade tasks with ``just --choose``, this includes tasks for build and running the app.



## 🏗️ Building locally, without the devcontainer

### You'll need the following dependencies:
> No need to manually download them if you use the devcontainer

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

### You can also get these optional tools for running tasks, code completion and generating doc:

* just
* fzf
* valadoc
* vala-language-server

### Install all for Fedora 41
> You will also need to manually get Docker for testing

```bash
sudo dnf install gtk4-devel ninja-build meson libadwaita-devel libgee-devel json-glib-devel desktop-file-utils libcurl-devel vala vala-language-server valadoc graphviz libglvnd just fzf
```

### Install all for Arch

> I recommand using paru or yay

```bash
paru -Syu gtk4 ninja meson libadwaita libgee json-glib desktop-file-utils curl libglvnd vala-language-server vala docker just fzf
```

## 🔨 Building
> All the command must be ran from the project root

#### With [just](https://github.com/casey/just) (recommanded)

First build of the project:
```
just init-build
```

Build the doc locally:
```
just generate-valadoc
```

Run ninja and launch the app
```
just ninja-run
```

Re-install the app
```
just install
```


#### Manually

```
meson build --prefix=/usr
cd build
ninja

sudo ninja install
./build/src/com.github.sdv43.whaler
```

## License
This project is licensed under the GPL-3.0 License - see the [LICENSE](LICENSE) file for details.