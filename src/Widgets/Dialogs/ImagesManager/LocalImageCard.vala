/*
   This file is part of Pilot Whale, a fork of Whaler by sdv43.

   Whaler is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License
   as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
   Whaler is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
   of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

   You should have received a copy of the GNU General Public License along with Whaler. If not, see <https://www.gnu.org/licenses/>.

   This fork, Pilot Whale, was created and modified by jumpyvi in 2025.
 */

using Docker;

class Widgets.Dialogs.ImageManager.LocalImageCard : Adw.Bin {
    private Image image;

    public LocalImageCard(Image image){
        this.image = image;
        Gtk.Grid grid = new Gtk.Grid ();
        Gtk.CheckButton check_button = new Gtk.CheckButton ();
    }
}