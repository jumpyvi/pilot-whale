/*
   This file is part of Whaler.

   Whaler is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License
   as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
   Whaler is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
   of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

   You should have received a copy of the GNU General Public License along with Whaler. If not, see <https://www.gnu.org/licenses/>.
 */

using Utils;

class Widgets.Screens.Container.SideBar : Adw.Bin {
    public SideBar (ScreenDockerContainer parent) {
        var state = State.Root.get_instance ().screen_docker_container;
        Gtk.ScrolledWindow scrolled_windows = new Gtk.ScrolledWindow ();
        var list_box = new Gtk.ListBox ();
        list_box.add_css_class ("list_box");
        child = scrolled_windows;

        scrolled_windows.width_request = 300;
        scrolled_windows.set_child (list_box);

        list_box.activate_on_single_click = false;
        list_box.selection_mode = Gtk.SelectionMode.SINGLE;
        list_box.row_selected.connect ((row) => {
            if (row.get_index () == -1) {
                return;
            }

            var side_bar_item = row as SideBarItem;
            assert_nonnull (side_bar_item);

            state.service = side_bar_item.service;
        });

        state.notify["container"].connect (() => {


        this.visible = (state.container.type == DockerContainerType.GROUP);
        parent.set_show_sidebar(this.visible);


        list_box.remove_all ();

        var main_container_item = new SideBarItem (state.container);
        var separator_item = new SideBarSeparator (_ ("Services"));
        separator_item.margin_top = 15;
        separator_item.add_css_class ("separator");

        list_box.append (main_container_item);
        list_box.append (separator_item);

        var selected_item = main_container_item;

        foreach (var service in state.container.services) {
            var item = new SideBarItem (service);

            list_box.append (item);

            if (state.service != null && state.service.id == service.id) {
                selected_item = item;
            }
        }

        state.service = selected_item.service;

        list_box.select_row (selected_item);
        list_box.show ();
    });
    }
}