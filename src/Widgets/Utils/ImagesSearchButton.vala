/*
 * This file is part of Whaler.
 * Whaler is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 * Whaler is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
 * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 * You should have received a copy of the GNU General Public License along with Whaler. If not, see <https://www.gnu.org/licenses/>.
 */
using Utilities;
using Widgets.Dialogs;
public class Widgets.Utils.ImagesSearchButton : Gtk.Button{
    private Adw.ButtonContent button_content = new Adw.ButtonContent ();
    private const string BUTTON_ICON_NAME = "folder-download-symbolic";
    private const string TOOLTIP_CONTENT = "Get container image";

    construct{
        button_content.set_icon_name (BUTTON_ICON_NAME);
        button_content.set_tooltip_text (TOOLTIP_CONTENT);
        this.set_child (button_content);

        this.clicked.connect ((button) => {
            var dialog = new ImagesSearchDialog();
            dialog.present(this);
        });
    }

    public ImagesSearchButton () {
        Object ();
    }
}