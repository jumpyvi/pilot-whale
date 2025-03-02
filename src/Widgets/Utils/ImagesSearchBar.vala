/*
   This file is part of Bubbler, a fork of Whaler by sdv43.

   Whaler is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License
   as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
   Whaler is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
   of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

   You should have received a copy of the GNU General Public License along with Whaler. If not, see <https://www.gnu.org/licenses/>.

   This fork, Bubbler, was created and modified by jumpyvi in 2025.
 */

using Docker;
using Utilities;
using Widgets.Dialogs;

class Widgets.Utils.ImagesSearchBar : Gtk.Box {
    private Gtk.SearchEntry search_bar;
    Gtk.Image search_image;
    Widgets.Dialogs.ImagesSearchDialog img_search_dialog;

    construct {
        var state = State.Root.get_instance();
        search_bar = new Gtk.SearchEntry();
        search_image = new Gtk.Image();
        this.orientation = Gtk.Orientation.HORIZONTAL;
        

        search_bar.width_request = 240;
        search_bar.placeholder_text = _("Search DockerHub...");
        search_bar.search_delay = 600;

        search_bar.search_changed.connect(() => {
            update_search();
        });

        this.append(search_bar);
        this.append(search_image);
        this.halign = Gtk.Align.CENTER;
    }

    public ImagesSearchBar(Widgets.Dialogs.ImagesSearchDialog img_search_dialog) {
        Object();
        this.img_search_dialog = img_search_dialog;
    }

    private void update_search(){
        var api_client = new ApiClient();

        api_client.find_remote_image_from_string.begin(clean_image_name(search_bar.text), (obj, res) => {
        try {
            var images = api_client.find_remote_image_from_string.end(res);
            img_search_dialog.update_image_list (images);
        } catch (Error e) {
            print("Error: %s\n", e.message);
        }
        });
    }

    public Gtk.SearchEntry get_search_bar(){
        return search_bar;
    }
}