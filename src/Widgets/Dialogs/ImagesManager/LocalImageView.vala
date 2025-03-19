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
class Widgets.Dialogs.ImagesManager.LocalImageView : Adw.Bin {

    public LocalImageView(){
        this.set_child(build_content_area());
        ApiClient api = new ApiClient();

        api.list_local_images.begin((obj, res) => {
            try {
                var values = api.list_local_images.end(res);
                foreach (var value in values) {
                    print("%s\n", value.name);
                }
            } catch (Error e) {
                warning("Failed to list local images: %s", e.message);
            }
        });
    }

    /**
     * Builds the content area of the dialog.
     *
     * @return The content area widget.
     */
    private Gtk.Widget build_content_area(){
        var box = new Gtk.Box(Gtk.Orientation.VERTICAL,0);
        box.append(build_local_image_list());
        return box;
    }

    private Gtk.Box build_local_image_list(){
        Gtk.Box local_images_list = new Gtk.Box(Gtk.Orientation.VERTICAL, 2);
        var api_client = new ApiClient();

        api_client.list_local_images.begin((obj, res) => {
        try {
            var local_images = api_client.list_local_images.end(res);
            foreach (var image in local_images) {
                local_images_list.append(new LocalImageCard(image));
            }
        } catch (Error e) {
            print("Error: %s\n", e.message);
        }
        });


        return local_images_list;
    }

}