/*
 * This file is part of Whaler.
 * Whaler is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 * Whaler is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
 * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 * You should have received a copy of the GNU General Public License along with Whaler. If not, see <https://www.gnu.org/licenses/>.
 */

 public class Widgets.Utils.ReloadButton : Adw.Bin {
    private Gtk.Button reload_button = new Gtk.Button ();
    private Adw.ButtonContent button_content = new Adw.ButtonContent ();
    private static ReloadButton? instance;
    private string icon_name = "view-refresh-symbolic";
    private string tooltip_content = "Refresh";

    construct{
        button_content.set_icon_name (icon_name);
        button_content.set_tooltip_text (tooltip_content);
        reload_button.set_child (button_content);
        this.set_child (reload_button);
    }

    private  ReloadButton () {
        Object ();
    }

    public static ReloadButton get_instance () {
        if (ReloadButton.instance == null) {
            ReloadButton.instance = new ReloadButton ();
        }
        return ReloadButton.instance;
    }
 }