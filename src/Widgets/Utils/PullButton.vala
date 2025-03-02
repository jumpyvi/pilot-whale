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
class Widgets.Utils.PullButton : Gtk.Button {
    public string image_name;
    public bool append_tag_latest;

    public PullButton(){
        var api_client = new ApiClient();
        this.icon_name = "folder-download-symbolic";

        this.clicked.connect(() => {
            this.set_icon_name("process-working-symbolic");
            this.sensitive = false;
            this.add_css_class("load-animation");
            string image_to_pull = image_name;
            if (append_tag_latest) {
                image_to_pull += ":latest";
            }
            print(image_to_pull);
            api_client.pull_image.begin(image_to_pull, (obj, res) => {
                try {
                    if(api_client.pull_image.end(res)){
                        print("Image pulled");
                        this.remove_css_class("load-animation");
                        this.set_icon_name("emoji-body-symbolic");
                        this.add_css_class("success-animation");
                        this.sensitive = false;
                        this.add_css_class("success");
                    }
                } catch (Error e) {
                    Widgets.ScreenManager.screen_error_show_widget (new Adw.AlertDialog (
                        _("Could not pull image " + image_to_pull),
                         _("Check if the path is correct and if the image/tag exist on the remote"))
                        );
                    this.reset();
                    print("Error: %s\n", e.message);
                }
            });
            
        });


    }

    public void set_image_name(string image_name){
        this.image_name = image_name;
    }

    public void set_append_tag_latest(bool append_tag_latest){
        this.append_tag_latest = append_tag_latest;
    }

    public void reset(){
        this.set_icon_name("folder-download-symbolic");
        this.remove_css_class("load-animation");
        this.remove_css_class("success-animation");
        this.remove_css_class("success");
        this.set_sensitive(true);
    }


}