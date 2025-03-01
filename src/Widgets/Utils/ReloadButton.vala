/*
 * This file is part of Whaler.
 * Whaler is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 * Whaler is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
 * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 * You should have received a copy of the GNU General Public License along with Whaler. If not, see <https://www.gnu.org/licenses/>.
 */
 using Utilities;
 public class Widgets.Utils.ReloadButton : Gtk.Button {
    private Adw.ButtonContent button_content = new Adw.ButtonContent ();
    private const string BUTTON_ICON_NAME = "view-refresh-symbolic";
    private const string TOOLTIP_CONTENT = "Refresh";

    construct{
        var state = State.Root.get_instance ();
        button_content.set_icon_name (BUTTON_ICON_NAME);
        button_content.set_tooltip_text (TOOLTIP_CONTENT);
        this.set_child (button_content);
        

        this.clicked.connect ((button) => {
            this.add_css_class ("refresh-animation");
            this.set_sensitive (false);

            Timeout.add (600, () => {
               this.remove_css_class ("refresh-animation");
                this.set_sensitive (true);
                return false;
            }, Priority.LOW);

            Reloader.reload();
        });

        this.show.connect (() => {
            this.sensitive = state.active_screen == ScreenMain.CODE
                                       || state.active_screen == ScreenError.CODE;
        });

        state.notify["active-screen"].connect (() => {
            this.sensitive = state.active_screen == ScreenMain.CODE
                                       || state.active_screen == ScreenError.CODE;
        });
    }

    public ReloadButton () {
        Object ();
    }

 }