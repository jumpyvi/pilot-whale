/*
   This file is part of Bubbler, a fork of Whaler by sdv43.

   Whaler is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License
   as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
   Whaler is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
   of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

   You should have received a copy of the GNU General Public License along with Whaler. If not, see <https://www.gnu.org/licenses/>.

   This fork, Bubbler, was created and modified by jumpyvi in 2025.
 */

using Utilities;
using Docker;

class Widgets.Screens.Container.LogViewer : Adw.Bin {
    public LogViewer () {
        Gtk.ScrolledWindow scrolled_window = new Gtk.ScrolledWindow ();
        var state_root = State.Root.get_instance ();
        var state_docker_container = state_root.screen_docker_container;
        var text_view = new Gtk.TextView ();
        var log_buffer = new Gtk.TextBuffer (null);
        scrolled_window.vexpand = true;

        scrolled_window.add_css_class ("log-frame");

        text_view.add_css_class ("terminal");
        text_view.editable = false;
        text_view.cursor_visible = false;
        text_view.buffer = log_buffer;
        scrolled_window.set_child (text_view);

        scrolled_window.vadjustment.changed.connect (() => {
            if (state_docker_container.is_autoscroll_enabled) {
                scrolled_window.vadjustment.value = scrolled_window.vadjustment.upper - scrolled_window.vadjustment.page_size;
            }
        });

        ContainerLogWatcher? log_watcher = null;
        DockerContainer? selected_container = null;

        state_docker_container.notify["service"].connect (() => {
            var is_container_changed = true;

            if (selected_container != null) {
                 is_container_changed = selected_container.id != state_docker_container.service.id;
            }

            selected_container = state_docker_container.service;

            if (is_container_changed) {
                if (log_watcher != null) {
                    log_watcher.watching_stop ();
                    log_buffer.text = "";
                }

                log_watcher = new ContainerLogWatcher (selected_container, log_buffer);
                log_watcher.watching_start ();
            } else {
                log_watcher.watching_start ();
            }
        });
        child = scrolled_window;
    }
}
