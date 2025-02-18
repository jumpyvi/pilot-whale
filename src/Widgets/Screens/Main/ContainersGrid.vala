/*
   This file is part of Whaler.

   Whaler is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License
   as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
   Whaler is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
   of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

   You should have received a copy of the GNU General Public License along with Whaler. If not, see <https://www.gnu.org/licenses/>.
 */

class Widgets.Screens.Main.ContainersGrid : Gtk.Stack {
    public const string CODE = "main";

    private signal void container_cards_updated();

    public ContainersGrid () {
        var state = State.Root.get_instance ();
        var state_main = state.screen_main;

        this.add_named (this.build_loader (), "loader");
        this.add_named (this.build_notice (), "no-containers");
        this.add_named (this.build_grid (), "containers");

        state_main.notify["containers-prepared"].connect (() => {
            if (state_main.containers_prepared.size > 0) {
                this.set_visible_child_name ("containers");

                if (state.active_screen == ContainersGrid.CODE) {
                    this.container_cards_updated ();
                }
            } else {
                this.set_visible_child_name ("no-containers");
            }
        });

        state.notify["active-screen"].connect (() => {
            if (state.active_screen == ContainersGrid.CODE) {
                this.container_cards_updated ();
            }
        });
    }

    private Gtk.Widget build_grid () {
        var state = State.Root.get_instance ();
        var state_main = state.screen_main;
        var root = new Gtk.ScrolledWindow ();

        var flow_box = new Gtk.FlowBox ();
        flow_box.get_style_context ().add_class ("docker-containers-grid"); // todo
        flow_box.homogeneous = true;
        flow_box.valign = Gtk.Align.START;
        flow_box.min_children_per_line = 2;
        flow_box.max_children_per_line = 7;
        flow_box.selection_mode = Gtk.SelectionMode.NONE;
        flow_box.activate_on_single_click = true;
        //  flow_box.child_activated.connect ((child) => {
        //      state.screen_docker_container.container = state_main.containers_prepared[child.get_index ()];
        //      state.next_screen (Widgets.ScreenDockerContainer.CODE);
        //  }); // todo
        root.set_child (flow_box);

        this.container_cards_updated.connect (() => {
            flow_box.remove_all ();

            foreach (var container in state_main.containers_prepared) {
                flow_box.append (new ContainerCard (container));
            }

            // todo flow_box.show_all ();
        });

        return root;
    }

    private Gtk.Widget build_loader () {
        var loader = new Gtk.Spinner ();

        loader.width_request = 32;
        loader.height_request = 32;
        loader.halign = Gtk.Align.CENTER;
        loader.valign = Gtk.Align.CENTER;

        loader.start ();

        return loader;
    }

    private Gtk.Widget build_notice () {
        var label = new Gtk.Label (_ ("No containers"));

        label.get_style_context ().add_class ("h3");
        label.halign = Gtk.Align.CENTER;
        label.valign = Gtk.Align.CENTER;

        return label;
    }
}
