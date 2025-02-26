/*
   This file is part of Whaler.

   Whaler is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License
   as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
   Whaler is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
   of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

   You should have received a copy of the GNU General Public License along with Whaler. If not, see <https://www.gnu.org/licenses/>.
 */
using Docker;
using Adw;

class Widgets.Utils.ImageCard : Adw.Bin {
    private Image image;

    public ImageCard(Image image) {
        this.image = image;
        var grid = new Gtk.Grid();

        // Name
        grid.attach(create_name(), 1, 1, 1, 1);

        // Description Button
        grid.attach(create_short_description(), 1, 2, 20, 20);

        // Official checkmark
        grid.attach(create_checkmark(), 2, 1, 1, 1);

        // Star count
        grid.attach(create_star_count(), 3, 1, 1, 1);

        // Grid style
        grid.add_css_class("card");
        grid.add_css_class("shadow");
        grid.height_request = 80;
        grid.margin_top = 4;
        grid.margin_start = 5;
        grid.margin_end = 5;
        grid.focusable = true;
        grid.vexpand = false;
        this.set_child(grid);
    }


    private Gtk.Box create_checkmark(){
        Gtk.Box official_box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);

        if (image.is_official){
            Gtk.Image checkmark = new Gtk.Image.from_icon_name("verified-checkmark-symbolic");
            official_box.append(checkmark);
            official_box.margin_start = 2;
            official_box.margin_top = 8;
            checkmark.tooltip_text = "Official image";

            official_box.add_css_class("official");
        }

        return official_box;
    }

    private Gtk.Label create_name(){
        Gtk.Label name_label = new Gtk.Label(this.image.name);
        name_label.margin_top = 8;
        name_label.margin_start = 10;
        return name_label;
    }

    private Gtk.Box create_star_count(){
        Gtk.Image star_image = new Gtk.Image.from_icon_name("starred-symbolic");
        Gtk.Label star_count_label = new Gtk.Label(this.image.star_count.to_string());
        Gtk.Box star_box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 1);
        star_box.append(star_image);
        star_box.append(star_count_label);
        star_box.margin_start = 260;
        star_box.margin_top = 9;
        star_box.add_css_class("star");

        return star_box;
    }

    private Gtk.Button create_short_description(){
        string short_description = this.image.description.length > 50 ? this.image.description.substring(0, 30) + "..." : this.image.description;
        Gtk.Button description_button = new Gtk.Button.with_label("");
        Gtk.Label description_text = new Gtk.Label(short_description);

        description_text.add_css_class("body");

        description_button.set_child(description_text);
        description_button.margin_top = 1;
        description_button.margin_bottom = 0;
        description_button.set_has_frame(false);
        description_button.hexpand = true;
        description_button.vexpand = true;
        description_button.set_tooltip_text("Click for full description");
        description_button.clicked.connect(() => {
            show_description_dialog();
        });

        return description_button;
    }

    private void show_description_dialog() {
        Adw.Dialog dialog = new Adw.Dialog();
        dialog.set_title("Description of " + this.image.name);
        dialog.set_content_height(800);
        dialog.set_content_width(800);

        Adw.HeaderBar headerbar = new Adw.HeaderBar();
        var toolbarview = new Adw.ToolbarView ();
        toolbarview.content = build_description_content();

        toolbarview.add_top_bar (headerbar);
        dialog.child = toolbarview;


        dialog.present(this);
    }

    private Gtk.Widget build_description_content(){
        Gtk.ScrolledWindow scrolled_window = new Gtk.ScrolledWindow();
        Gtk.TextView description_textview = new Gtk.TextView();
        description_textview.buffer.text = this.image.description;
        description_textview.editable = false;
        description_textview.cursor_visible = false;
        description_textview.wrap_mode = Gtk.WrapMode.WORD;
        description_textview.hexpand = true;
        scrolled_window.set_child(description_textview);
        scrolled_window.min_content_height = 200;

        return scrolled_window;
    } 
}