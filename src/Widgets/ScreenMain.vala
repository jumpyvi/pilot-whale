/*
   This file is part of Whaler.

   Whaler is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License
   as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
   Whaler is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
   of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

   You should have received a copy of the GNU General Public License along with Whaler. If not, see <https://www.gnu.org/licenses/>.
 */

using Widgets.Screens.Main;

class Widgets.ScreenMain : Gtk.Box {
    public const string CODE = "main";

    public ScreenMain () {
        this.orientation = Gtk.Orientation.VERTICAL;
        this.spacing = 0;

        // todo - replace this fonction
        // this.get_style_context ().add_class ("screen-main");

        ContainersGridFilter container_grid_filter = new ContainersGridFilter ();
        ContainersGrid container_grid = new ContainersGrid ();

        this.prepend (container_grid_filter);
        this.prepend (container_grid);
    }
}
