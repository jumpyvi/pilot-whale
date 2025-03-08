export DBUS_SESSION_BUS_ADDRESS := `dbus-daemon --fork --config-file=/usr/share/dbus-1/session.conf --print-address`
export DISPLAY := ':0'

alias run := ninja-run
alias l := launch
alias i := init-build

default: 
    just --choose

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
    ./build/com.github.jumpyvi.pilot-whale

# Install firefox for test xdg-open redirect
install-test-browser:
    sudo dnf install firefox alsa-lib -y

# # Run all tests (only builds TestsSyntaxHighlighter if it dosent already exist)
# run-all-tests:
#     if [ ! -f ./TestsSyntaxHighlighter ]; then valac tests/Utils/TestsSyntaxHighlighter.vala; fi; \
#     for file in ./tests/*.test.vala; do vala "$file" | ./TestsSyntaxHighlighter; done

ninja-test:
    ninja test -C build

# run-single-test +FILE:
#     @if [ ! -f ./TestsSyntaxHighlighter ]; then valac tests/Utils/TestsSyntaxHighlighter.vala; fi; \
#     if [ -f "tests/{{FILE}}.test.vala" ]; then \
#         vala tests/{{FILE}}.test.vala | ./TestsSyntaxHighlighter; \
#     else \
#         echo "File {{FILE}} not found! Only use the test file title (example.test.vala becomes example)"; \
#     fi

# Generate the valadoc locally
generate-valadoc:
    rm -rf docs
    valadoc --package-version=dev --package-name="com.github.jumpyvi.pilot-whale" --vapidir=$(pwd)/vapi --pkg gtk4 --pkg libadwaita-1 --pkg json-glib-1.0 --pkg gio-2.0 --pkg gee-0.8 --pkg posix --pkg libcurl -o docs $(find src -name "*.vala") build/src/Constants.vala build/src/Build.vala

# Perfect task for first run
init-build: meson-build ninja install launch
