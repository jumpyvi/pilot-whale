/*
 * This file is part of Whaler.
 * Whaler is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 * Whaler is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
 * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 * You should have received a copy of the GNU General Public License along with Whaler. If not, see <https://www.gnu.org/licenses/>.
 */
 public class Widgets.Utils.ActionMenu : Adw.Bin {
    public ActionMenu(){
        Gtk.MenuButton menu_button = new Gtk.MenuButton ();
        menu_button.has_frame = false;
        menu_button.icon_name = "view-more-symbolic";
        menu_button.sensitive = true;
        menu_button.set_popover (build_menu (this));

        this.set_child (menu_button);
    }

    private Gtk.PopoverMenu build_menu (Gtk.Widget parent) {
        Gtk.PopoverMenu menu = new Gtk.PopoverMenu.from_model (build_menu_model());
        
        parent.insert_action_group ("container", create_actions ());

        return menu;
    }

    private GLib.MenuModel build_menu_model (){
        Menu menu_content = new Menu ();
        menu_content.append ("Pause", "container.pause");
        menu_content.append ("Restart", "container.restart");
        menu_content.append ("Remove", "container.remove");
        menu_content.append ("Info", "container.info");

        return menu_content;
    }

    private SimpleActionGroup create_actions (){
        SimpleActionGroup action_group = new SimpleActionGroup ();

        // Pause action
        SimpleAction pause_action = new SimpleAction ("pause", null);
        pause_action.activate.connect ((parameter) => {
            print("Pausing...\n");
        });

        // Restart action
        SimpleAction restart_action = new SimpleAction ("restart", null);
        restart_action.activate.connect ((parameter) => {
            print("Restarting...\n");
        });

        // Remove action
        SimpleAction remove_action = new SimpleAction ("remove", null);
        remove_action.activate.connect ((parameter) => {
            print("Removing...\n");
        });

        // Info action
        SimpleAction info_action = new SimpleAction ("info", null);
        info_action.activate.connect ((parameter) => {
            print("Infoing...\n");
        });

        // Add actions to the action group
        action_group.add_action (pause_action);
        action_group.add_action (restart_action);
        action_group.add_action (remove_action);
        action_group.add_action (info_action);

        return action_group;
    }
    
 }