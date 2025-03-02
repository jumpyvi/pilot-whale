/*
   This file is part of Bubbler, a fork of Whaler by sdv43.

   Whaler is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License
   as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
   Whaler is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
   of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

   You should have received a copy of the GNU General Public License along with Whaler. If not, see <https://www.gnu.org/licenses/>.

   This fork, Bubbler, was created and modified by jumpyvi in 2025.
 */

using Widgets.Screens.Main;

class Widgets.ScreenMain : Gtk.Box {
    public const string CODE = "main";

    public ScreenMain () {
        this.orientation = Gtk.Orientation.VERTICAL;
        this.spacing = 0;

        ContainersGridFilter container_grid_filter = new ContainersGridFilter ();
        ContainersGrid container_grid = new ContainersGrid ();

        this.prepend (container_grid);
        this.prepend (container_grid_filter);
    }
}
