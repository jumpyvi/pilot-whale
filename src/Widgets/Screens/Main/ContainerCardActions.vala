/*
   This file is part of Whaler.

   Whaler is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License
   as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
   Whaler is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
   of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

   You should have received a copy of the GNU General Public License along with Whaler. If not, see <https://www.gnu.org/licenses/>.
 */

using Utils;

class Widgets.Screens.Main.ContainerCardActions : Gtk.Box {
    private DockerContainer container;

    public ContainerCardActions (DockerContainer container) {
        this.container = container;
        this.orientation = Gtk.Orientation.HORIZONTAL;
        this.spacing = 0;
        this.prepend (this.build_button_main_action());
        this.prepend (this.build_button_menu_action ()); // todo
    }

    private Gtk.Widget build_button_main_action () {
        var icon_name = "media-playback-start-symbolic";
        string css_class = "suggested-action";

        if (this.container.state == DockerContainerState.RUNNING) {
            icon_name = "media-playback-stop-symbolic";
            css_class = "destructive-action";
        }

        var button = new Gtk.Button.from_icon_name (icon_name);
        button.valign = Gtk.Align.CENTER;
        button.clicked.connect (() => {
            this.sensitive = false;

            ContainerCardActions.button_main_action_handler.begin (this.container, (_, res) => {
                ContainerCardActions.button_main_action_handler.end (res);
                this.sensitive = true;
            });
        });
        
        button.add_css_class (css_class);
        return button;
    }

    private Gtk.MenuButton build_button_menu_action () {
        var menu_button = new Gtk.MenuButton ();
        menu_button.has_frame = false;
        menu_button.icon_name = "view-more-symbolic";
        menu_button.sensitive = true;
        menu_button.set_popover (build_menu (this));


        return menu_button;
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



    public static async void button_main_action_handler (DockerContainer container) {
        var state = State.Root.get_instance ();
        var err_msg = _ ("Container action error");

        try {
            switch (container.state) {
                case DockerContainerState.RUNNING:
                    err_msg = _ ("Container stop error");
                    ScreenManager.overlay_bar_show (_ ("Stopping container"));
                    yield state.container_stop(container);
                    break;

                case DockerContainerState.STOPPED:
                    err_msg = _ ("Container start error");
                    ScreenManager.overlay_bar_show (_ ("Starting container"));
                    yield state.container_start(container);
                    break;

                case DockerContainerState.PAUSED:
                    err_msg = _ ("Container unpause error");
                    yield state.container_unpause(container);
                    break;

                case DockerContainerState.UNKNOWN:
                    var error_widget = new Adw.AlertDialog (err_msg, _ ("Container state is unknown"));
                    ScreenManager.screen_error_show_widget (error_widget);
                    break;
            }
        } catch (Docker.ApiClientError error) {
            var error_widget = new Adw.AlertDialog (err_msg, error.message);
            ScreenManager.screen_error_show_widget (error_widget);
        } finally {
            ScreenManager.overlay_bar_hide ();
        }
    }
}
