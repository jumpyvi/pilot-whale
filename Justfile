export DBUS_SESSION_BUS_ADDRESS := `dbus-daemon --fork --config-file=/usr/share/dbus-1/session.conf --print-address`

default: ninja-run

# Runs ninja on the project
[working-directory('build')]
ninja:
    ninja

# Installs the schema
[working-directory('build')]
install:
    sudo ninja install

# Run ninja and launch at the same time for quick edits
ninja-run: ninja launch

# Uses meson to build the project
meson-build:
    meson build --prefix=/usr

# Uses meson to reconfigure the project
meson-reconfigure:
    meson setup --reconfigure --prefix=/usr build

# Launch the project
launch:
    ./build/src/com.github.jumpyvi.pilot-whale

# Install firefox for test xdg-open redirect
install-test-browser:
    paru -Syu --noconfirm firefox-bin alsa-lib

# Generate the valadoc locally
generate-valadoc:
    rm -rf docs
    valadoc --package-version=dev --package-name="com.github.jumpyvi.pilot-whale" --vapidir=$(pwd)/vapi --pkg gtk4 --pkg libadwaita-1 --pkg json-glib-1.0 --pkg gio-2.0 --pkg gee-0.8 --pkg posix --pkg libcurl -o docs $(find src -name "*.vala") build/src/Constants.vala build/src/Build.vala

# Perfect task for first run
init-build: meson-build ninja install launch