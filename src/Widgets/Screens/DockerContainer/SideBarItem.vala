/*
   This file is part of Pilot Whale, a fork of Whaler by sdv43.

   Whaler is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License
   as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
   Whaler is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
   of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

   You should have received a copy of the GNU General Public License along with Whaler. If not, see <https://www.gnu.org/licenses/>.

   This fork, Pilot Whale, was created and modified by jumpyvi in 2025.
 */

using Utilities;

/**
* An item in the docker container view sidebar
*/
class Widgets.Screens.Container.SideBarItem : Gtk.ListBoxRow {
    public DockerContainer service;

    /**
    * Create a new item in the sidebar
    * @param The docker container to add as an item
    */
    public SideBarItem (DockerContainer service) {
        var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);

        this.service = service;
        this.activatable = false;
        this.selectable = true;
        this.set_child (box);

        //
        var container_name = new Gtk.Label (service.name);

        container_name.max_width_chars = 16;
        container_name.ellipsize = Pango.EllipsizeMode.END;
        container_name.halign = Gtk.Align.START;
        box.prepend (container_name);

        //
        var container_image = new Gtk.Label (service.image);

        container_image.max_width_chars = 16;
        container_image.ellipsize = Pango.EllipsizeMode.END;
        container_image.halign = Gtk.Align.START;
        box.append (container_image);
    }
}
