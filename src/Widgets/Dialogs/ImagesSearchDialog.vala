/*
   This file is part of Bubbler, a fork of Whaler by sdv43.

   Whaler is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License
   as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
   Whaler is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
   of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

   You should have received a copy of the GNU General Public License along with Whaler. If not, see <https://www.gnu.org/licenses/>.

   This fork, Bubbler, was created and modified by jumpyvi in 2025.
 */

using Utilities;
using Docker;
using Widgets.Utils;

class Widgets.Dialogs.ImagesSearchDialog : Adw.Dialog {
    protected Adw.HeaderBar headerbar { get; set; }
    Gtk.Box images_list;
    Gtk.Stack content_view;
    ImagesSearchBar searchbar;

    public ImagesSearchDialog (){
        this.set_content_height (600);
        this.set_content_width (420);
        content_view = new Gtk.Stack(){
            transition_type = Gtk.StackTransitionType.SLIDE_UP_DOWN,
            transition_duration = 500
        };

        searchbar = new Utils.ImagesSearchBar(this);

        content_view.add_named(build_info_view(), "info_view");
        content_view.add_named(build_image_list_area(), "image-list");

        content_view.set_visible_child_name("info_view");

        var toolbarview = new Adw.ToolbarView () {
			content = build_content_area()
		};
		headerbar = new Adw.HeaderBar ();
		toolbarview.add_top_bar (headerbar);
		this.child = toolbarview;
    }

    private Gtk.Widget build_content_area(){
        var box = new Gtk.Box(Gtk.Orientation.VERTICAL,0);
        box.append(searchbar);

        box.append(content_view);
        return box;
    }

    private Gtk.Widget build_image_list_area(){
        Gtk.ScrolledWindow scrolled_window = new Gtk.ScrolledWindow();

        images_list = new Gtk.Box(Gtk.Orientation.VERTICAL, 2);
        
        images_list.margin_top = 10;
        scrolled_window.vexpand = true;
        scrolled_window.set_child(images_list);

        return scrolled_window;
    }

    public void update_image_list(Docker.Image[] images){
        if (clean_image_name(searchbar.get_search_bar().text).length != 0){
            content_view.set_visible_child_name("image-list");
        }else{
            content_view.set_visible_child_name("info_view");
        }

        while (images_list.get_first_child() != null){
            images_list.remove(images_list.get_first_child());
        }

        foreach (var image in images){
            images_list.append(new ImageCard (image));
        }
    }

    private Gtk.Box build_info_view(){
        Gtk.Box info_box = new Gtk.Box(Gtk.Orientation.VERTICAL, 2);
        info_box.set_valign(Gtk.Align.CENTER);
        Gtk.Image search_indicator = new Gtk.Image() {
            icon_name = "system-search",
            pixel_size = 100,
            hexpand = true,
        };
        Gtk.Label search_info_label = new Gtk.Label(_("Start typing above to search images on DockerHub"));
        search_info_label.add_css_class("heading");
        search_info_label.set_margin_top(40);
        Gtk.Label other_registries_info_label = new Gtk.Label(_("Or use the input below to pull images from other registries"));
        other_registries_info_label.margin_top = 5;

        
        info_box.append(search_indicator);
        info_box.append(search_info_label);
        info_box.append(other_registries_info_label);
        info_box.append(build_other_registries_view());


        return info_box;
    }

    private Gtk.Box build_other_registries_view() {
        Gtk.Box other_registries_box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 4);
        other_registries_box.margin_top = 14;
        Utils.PullButton pull_button = new Utils.PullButton();
        other_registries_box.halign = Gtk.Align.BASELINE_CENTER;

        var settings = new GLib.Settings("com.github.jumpyvi.blubber");
        string[] valid_registries = settings.get_strv("valid-registry-prefixes");

        var registry_model = new Gtk.StringList(valid_registries);
        registry_model.append("custom");

        Gtk.DropDown registry_dropdown = new Gtk.DropDown(registry_model, null);
        registry_dropdown.halign = Gtk.Align.CENTER;

        Gtk.SearchEntry name_entry = new Gtk.SearchEntry();
        name_entry.halign = Gtk.Align.CENTER;

        registry_dropdown.notify["selected-item"].connect(() => {
            name_entry.search_changed();
        });

        name_entry.search_changed.connect((search)=>{
            string image_name = ((Gtk.StringObject) registry_dropdown.get_selected_item()).get_string() + clean_image_name(name_entry.text);
            if (image_name.has_prefix("custom")) {
                image_name = image_name.substring(6);
            }
            pull_button.set_image_name(image_name);

            pull_button.set_append_tag_latest(!name_entry.text.contains(":"));
            pull_button.reset();
        });


        other_registries_box.append(registry_dropdown);
        other_registries_box.append(name_entry);

        other_registries_box.append(pull_button);

        return other_registries_box;
}

}