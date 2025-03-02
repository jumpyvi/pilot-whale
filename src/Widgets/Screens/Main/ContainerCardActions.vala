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
using Widgets.Utils;

class Widgets.Screens.Main.ContainerCardActions : Gtk.Box {
    private DockerContainer container;

    public ContainerCardActions (DockerContainer container) {
        this.container = container;
        this.orientation = Gtk.Orientation.HORIZONTAL;
        this.spacing = 0;
        this.prepend (new Widgets.Utils.MainAction (container));
        this.prepend (new Widgets.Utils.ActionMenu(container));
    }
}
