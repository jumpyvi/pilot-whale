/*
   This file is part of Pilot Whale, a fork of Whaler by sdv43.

   Whaler is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License
   as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
   Whaler is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
   of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

   You should have received a copy of the GNU General Public License along with Whaler. If not, see <https://www.gnu.org/licenses/>.

   This fork, Pilot Whale, was created and modified by jumpyvi in 2025.
 */

using Widgets;
using Widgets.Utils;
using Adw;

[GtkTemplate (ui = "/com/github/jumpyvi/pilot-whale/window.ui")]
public class PilotWhale.Window : Adw.ApplicationWindow {
    [GtkChild]
    private unowned Adw.Bin screen_manager_placeholder;
    [GtkChild]
    private unowned Gtk.Box headerbar_buttons_box;

    public Window (Gtk.Application app) {
        Object (application: app);

        screen_manager_placeholder.set_child (ScreenManager.get_instance ());
        headerbar_buttons_box.append (new BackButton());
        headerbar_buttons_box.append (new ReloadButton());
        headerbar_buttons_box.append (new ImagesSearchButton ());
    }
}
