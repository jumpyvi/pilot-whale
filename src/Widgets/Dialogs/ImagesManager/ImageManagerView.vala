/*
   This file is part of Pilot Whale, a fork of Whaler by sdv43.

   Whaler is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License
   as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
   Whaler is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
   of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

   You should have received a copy of the GNU General Public License along with Whaler. If not, see <https://www.gnu.org/licenses/>.

   This fork, Pilot Whale, was created and modified by jumpyvi in 2025.
 */

class Widgets.Dialogs.ImagesManager.ImageManagerView : Adw.Bin {

    public ImageManagerView(){
        this.set_child(build_content_area());
    }

    /**
     * Builds the content area of the dialog.
     *
     * @return The content area widget.
     */
    private Gtk.Widget build_content_area(){
        var box = new Gtk.Box(Gtk.Orientation.VERTICAL,0);
        box.append(new Gtk.Label("NYI"));
        return box;
    }

}