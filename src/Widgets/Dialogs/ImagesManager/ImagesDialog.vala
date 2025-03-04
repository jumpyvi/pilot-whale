/*
    This file is part of Pilot Whale, a fork of Whaler by sdv43.

    Whaler is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License
    as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
    Whaler is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
    of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along with Whaler. If not, see <https://www.gnu.org/licenses/>.

    This fork, Pilot Whale, was created and modified by jumpyvi in 2025.
 */

using Utilities;
using Docker;
using Widgets.Utils;

/**
 * A dialog for searching Docker images.
 */
class Widgets.Dialogs.ImagesManager.ImagesDialog : Adw.Dialog {
     protected Adw.HeaderBar headerbar { get; set; }
     private Adw.ViewStack view_stack;

     /**
      * Creates a new ImagesSearchDialog.
      */
     public ImagesDialog (){
          this.set_content_height (600);
          this.set_content_width (420);
          view_stack = build_view_stack();

          var toolbarview = new Adw.ToolbarView () {
                content = build_content_area()
          };
          headerbar = new Adw.HeaderBar ();
          headerbar.set_title_widget(new Gtk.Label("Image Manager"));
          toolbarview.add_top_bar (headerbar);
          this.child = toolbarview;
     }


     private Gtk.Box build_content_area(){
          Gtk.Box box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
          box.append(build_view_switcher());
          box.append(view_stack);

          return box;
     }

     private Adw.ViewSwitcher build_view_switcher(){
          Adw.ViewSwitcher switcher = new Adw.ViewSwitcher();
          switcher.set_stack(view_stack);
          switcher.policy = Adw.ViewSwitcherPolicy.WIDE;
          switcher.margin_bottom = 20;
          switcher.margin_start = 9;
          switcher.margin_end = 9;

          return switcher;
     }

     private Adw.ViewStack build_view_stack(){
          Adw.ViewStack view_stack = new Adw.ViewStack();
          view_stack.add_titled_with_icon(new ImagePullerView(), "image-puller-view", "Image Puller", "folder-download-symbolic");
          view_stack.add_titled_with_icon(new LocalImageView(), "image-local-view", "Local Images", "drive-multidisk-symbolic");

          return view_stack;
     }

}
