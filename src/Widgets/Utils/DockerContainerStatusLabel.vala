/*
   This file is part of Whaler.
   Whaler is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License
   as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
   Whaler is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
   of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
   You should have received a copy of the GNU General Public License along with Whaler. If not, see <https://www.gnu.org/licenses/>.
 */
using Utilities;

namespace Widgets.Utils {
    public class DockerContainerStatusLabel : Adw.Bin {
        private Gtk.Label status_label;

        construct {
            status_label = new Gtk.Label("");
            status_label.get_style_context().add_class("docker-container-status-label");
            child = status_label;
        }

        private DockerContainerStatusLabel(DockerContainer container) {
            Object();
            update_status(container);
        }

        private void update_status(DockerContainer container) {
            // Remove any existing state classes
            var context = status_label.get_style_context();
            context.remove_class("running");
            context.remove_class("paused");
            context.remove_class("stopped");
            context.remove_class("unknown");

            // Add appropriate class and text based on container state
            switch (container.state) {
                case DockerContainerState.RUNNING:
                    context.add_class("running");
                    status_label.set_text(_("Running"));
                    break;
                case DockerContainerState.PAUSED:
                    context.add_class("paused");
                    status_label.set_text(_("Paused"));
                    break;
                case DockerContainerState.STOPPED:
                    context.add_class("stopped");
                    status_label.set_text(_("Stopped"));
                    break;
                case DockerContainerState.UNKNOWN:
                    context.add_class("unknown");
                    status_label.set_text(_("Unknown"));
                    break;
            }
        }

        internal static Gtk.Widget? create_by_container(DockerContainer container) {
            var is_running = container.state == DockerContainerState.RUNNING;
            var is_paused = container.state == DockerContainerState.PAUSED;
            if (is_running || is_paused) {
                return new DockerContainerStatusLabel(container);
            }
            return null;
        }
    }
}