/*
   This file is part of Pilot Whale, a fork of Whaler by sdv43.

   Whaler is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License
   as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
   Whaler is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
   of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

   You should have received a copy of the GNU General Public License along with Whaler. If not, see <https://www.gnu.org/licenses/>.

   This fork, Pilot Whale, was created and modified by jumpyvi in 2025.
 */

public class Widgets.Utils.BackButton : Gtk.Button {
    private Adw.ButtonContent button_content = new Adw.ButtonContent ();
    private const string BUTTON_ICON_NAME = "go-previous-symbolic";
    private const string TOOLTIP_CONTENT = "Back";

    construct {
        var state = State.Root.get_instance ();
        button_content.set_icon_name (BUTTON_ICON_NAME);
        button_content.set_tooltip_text (TOOLTIP_CONTENT);
        this.set_child (button_content);
        this.visible = state.button_back_visible;

        this.clicked.connect ((button) => {
            state.prev_screen ();
        });

        this.show.connect (() => {
            this.visible = state.button_back_visible;
        });

        state.notify["button-back-visible"].connect (() => {
            this.visible = state.button_back_visible;
        });
    }
}