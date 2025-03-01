/*
   This file is part of Whaler.

   Whaler is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License
   as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
   Whaler is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
   of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

   You should have received a copy of the GNU General Public License along with Whaler. If not, see <https://www.gnu.org/licenses/>.
 */

using Utilities;
using Widgets.Screens.Main;

namespace Widgets.Screens.Container {
    class TopBarActions : Gtk.Box {
        private DockerContainer container;

        public TopBarActions (DockerContainer container) {
            this.container = container;
            this.sensitive = container.state != DockerContainerState.UNKNOWN;
            this.orientation = Gtk.Orientation.HORIZONTAL;
            this.spacing = 0;
            this.margin_start = 15;
            this.prepend (new Widgets.Utils.MainAction (this.container));
            this.append (new Widgets.Utils.ActionMenu (this.container));
        }
    }
}
