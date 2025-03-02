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

namespace Widgets.Utils {
    public class DockerContainerStatusLabel : Adw.Bin {
        private Gtk.Label status_label;

        construct {
            status_label = new Gtk.Label("");
            child = status_label;
        }

        private DockerContainerStatusLabel(DockerContainer container) {
            Object();
            update_status(container);
        }

        private void update_status(DockerContainer container) {

            // Add appropriate class and text based on container state
            switch (container.state) {
                case DockerContainerState.RUNNING:
                    status_label.set_text(_("Running"));
                    break;
                case DockerContainerState.PAUSED:
                    status_label.set_text(_("Paused"));
                    break;
                case DockerContainerState.STOPPED:
                    status_label.set_text(_("Stopped"));
                    break;
                case DockerContainerState.UNKNOWN:
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