/*
 * This file is part of Whaler.
 * Whaler is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 * Whaler is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
 * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 * You should have received a copy of the GNU General Public License along with Whaler. If not, see <https://www.gnu.org/licenses/>.
 */

using Docker;

class Widgets.Utils.ImagesSearchBar : Gtk.Box {
    Gtk.SearchEntry search;
    Gtk.Button action_button;
    Widgets.Dialogs.ImagesSearchDialog img_search_dialog;

    construct {
        var state = State.Root.get_instance();
        search = new Gtk.SearchEntry();
        var api_client = new ApiClient();
        bool is_direct_pull = false;
        this.orientation = Gtk.Orientation.HORIZONTAL;

        search.width_request = 240;
        search.placeholder_text = _("Search images...");
        search.search_delay = 600;
        search.search_changed.connect(() => {
            string clean_search_text = "";

            foreach (char c in search.text.to_utf8()) {
                if ((c >= '0' && c <= '9') || 
                    (c >= 'A' && c <= 'Z') || 
                    (c >= 'a' && c <= 'z') || 
                    c == '_' || c == '-' || c == '/' || c == '.') {
                    clean_search_text += c.to_string();
                }
            }

            var settings = new GLib.Settings("com.github.sdv43.whaler");
            string[] valid_registries = settings.get_strv("valid-registry-prefixes");

            bool has_valid_prefix = false;

            foreach (string prefix in valid_registries) {
                if (clean_search_text.has_prefix(prefix)) {
                    has_valid_prefix = true;
                    break;
                }
            }

            if (has_valid_prefix) {
                action_button.set_label (_("Pull from link"));
                print("Pulling from link\n");
            }else{
                action_button.set_label(_("Search"));
                print("Searching\n");
                
            }

            api_client.find_remote_image_from_string.begin(clean_search_text, (obj, res) => {
                try {
                    var images = api_client.find_remote_image_from_string.end(res);
                    img_search_dialog.update_image_list (images);
                } catch (Error e) {
                    print("Error: %s\n", e.message);
                }
            });
        });

        this.append(search);
        this.append(create_pull_button());
        this.margin_start = 25;
        this.margin_end = 3;
    }

    public ImagesSearchBar(Widgets.Dialogs.ImagesSearchDialog img_search_dialog) {
        Object();
        this.img_search_dialog = img_search_dialog;
    }

    private Gtk.Button create_pull_button() {
        action_button = new Gtk.Button.with_label("Search");
        action_button.clicked.connect(() => {
            search.search_changed();

        });
        action_button.margin_start = 10;
        return action_button;
    }
}