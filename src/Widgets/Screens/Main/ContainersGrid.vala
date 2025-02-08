/*
   This file is part of Whaler.

   Whaler is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License
   as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
   Whaler is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
   of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

   You should have received a copy of the GNU General Public License along with Whaler. If not, see <https://www.gnu.org/licenses/>.
 */

public class Widgets.Screens.Main.ContainersGrid : Adw.Bin {
    public const string CODE = "main";
    private Gtk.Stack stack;
    private signal void container_cards_updated();

    construct {
        // Initialize stack first
        stack = new Gtk.Stack();
        stack.transition_type = Gtk.StackTransitionType.CROSSFADE;
        
        var state = State.Root.get_instance();
        var state_main = state.screen_main;
        
        // Set child after stack is initialized
        child = stack;
        
        // Add named children to stack
        stack.add_named(build_loader(), "loader");
        stack.add_named(build_notice(), "no-containers");
        stack.add_named(build_grid(), "containers");
        
        // Set default stack
        stack.visible_child_name = "loader";
        
        state_main.notify["containers-prepared"].connect(() => {
            if (state_main.containers_prepared.size > 0) {
                stack.set_visible_child_name("containers");
                if (state.active_screen == ContainersGrid.CODE) {
                    this.container_cards_updated();
                }
            } else {
                stack.set_visible_child_name("no-containers");
            }
        });
        
        state.notify["active-screen"].connect(() => {
            if (state.active_screen == ContainersGrid.CODE) {
                this.container_cards_updated();
            }
        });
    }

    public ContainersGrid () {
        Object ();
    }

    
    private Gtk.Widget build_grid() {
        var state = State.Root.get_instance();
        var state_main = state.screen_main;
        
        // Configure ScrolledWindow
        var root = new Gtk.ScrolledWindow() {
            hexpand = true,
            vexpand = true,
        };
        
        // Configure FlowBox
        var flow_box = new Gtk.FlowBox() {
            homogeneous = true,
            valign = Gtk.Align.START,
            halign = Gtk.Align.FILL,
            hexpand = true,
            row_spacing = 12,
            column_spacing = 12,
            min_children_per_line = 2,
            max_children_per_line = 7,
            selection_mode = Gtk.SelectionMode.NONE,
            activate_on_single_click = true
        };
        flow_box.child_activated.connect ((child) => {
            state.screen_docker_container.container = state_main.containers_prepared[child.get_index ()];
            state.next_screen (Widgets.ScreenDockerContainer.CODE);
        });
        
        root.set_child(flow_box);

        // Update container cards
        this.container_cards_updated.connect(() => {
            flow_box.remove_all();
            foreach (var container in state_main.containers_prepared) {
                var card = new ContainerCard(container);
                // Ensure each card is visible
                card.visible = true;
                flow_box.append(card);
            }
        });
        
        return root;
}

    private Gtk.Widget build_loader () {
        var loader = new Adw.Spinner ();

        loader.width_request = 32;
        loader.height_request = 32;
        loader.halign = Gtk.Align.CENTER;
        loader.valign = Gtk.Align.CENTER;

        return loader;
        return null;
    }

    private Gtk.Widget build_notice () {
        var label = new Gtk.Label (_ ("No containers"));

        label.get_style_context ().add_class ("h3");
        label.halign = Gtk.Align.CENTER;
        label.valign = Gtk.Align.CENTER;

        return label;
    }
}
