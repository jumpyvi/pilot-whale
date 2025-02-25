/*
   This file is part of Whaler.

   Whaler is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License
   as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
   Whaler is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
   of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

   You should have received a copy of the GNU General Public License along with Whaler. If not, see <https://www.gnu.org/licenses/>.
*/

using Utils;
using Docker;

class Widgets.Dialogs.ContainerPullDialog : Adw.Dialog {
    protected Adw.HeaderBar headerbar { get; set; }

    public ContainerPullDialog (){
        this.set_content_height (600);
        this.set_content_width (400);

        var toolbarview = new Adw.ToolbarView () {
			content = build_content_area ()
		};
		headerbar = new Adw.HeaderBar ();
		toolbarview.add_top_bar (headerbar);
		this.child = toolbarview;
    }

    private Gtk.Widget build_content_area(){
        var box = new Gtk.Box(Gtk.Orientation.VERTICAL,0);
        box.append(new Utils.ContainerPullSearchBar());
        box.append(build_image_list_area());
        var api_client = new ApiClient();
        api_client.find_remote_image_from_string.begin("radarr", (obj, res) => {
            try {
            var images = api_client.find_remote_image_from_string.end(res);
            foreach (var image in images) {
                print("Image: %s\n", image.name);
            }
            } catch (Error e) {
            print("Error: %s\n", e.message);
            }
        });
        return box;
    }

    private Gtk.ListBox build_image_list_area(){
        Gtk.ListBox images_list = new Gtk.ListBox();

        return images_list;
    }

}