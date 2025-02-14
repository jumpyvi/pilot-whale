using Utils;
using Widgets;
using Posix;

class Widgets.Utils.ActionMenu : Adw.Bin {
    private Gtk.MenuButton menu_button;

    public ActionMenu(DockerContainer container) {
        menu_button = new Gtk.MenuButton();
        menu_button.has_frame = false;
        menu_button.icon_name = "view-more-symbolic";
        menu_button.sensitive = true;
        menu_button.set_popover(build_menu(this, container));

        this.set_child(menu_button);
    }

    private Gtk.Popover build_menu(Gtk.Widget parent, DockerContainer container) {
        Gtk.Popover popover = new Gtk.Popover();
        Gtk.Box action_box = new Gtk.Box(Gtk.Orientation.VERTICAL, 2);


        Gtk.Button info_action = new Gtk.Button.with_label("Info");
        action_box.append(create_pause_button(container));
        action_box.append(create_restart_button(container));
        action_box.append(create_remove_button(container));
        action_box.append(info_action);

        popover.set_child(action_box);

        return popover;
    }

    private Gtk.Button create_pause_button(DockerContainer container) {
        var state = State.Root.get_instance ();
        var pause_button = new Gtk.Button.with_label("Pause");
        pause_button.sensitive = container.state == DockerContainerState.RUNNING;
        pause_button.clicked.connect(() => {
            pause_button.label = "Pausing...";
            pause_button.sensitive = false;

            state.container_pause.begin(container, (_, res) => {
                try {
                    state.container_pause.end(res);
                }catch (Docker.ApiClientError error){
                    print(error.message);
                    ScreenManager.show_toast_with_content (error.message, 5);
                } finally {
                    pause_button.sensitive = true;
                    pause_button.label = "Paused";
                }
            });
        });
        
        return pause_button;
    }

    private Gtk.Button create_restart_button(DockerContainer container){
        var restart_button = new Gtk.Button.with_label("Restart");
        var state = State.Root.get_instance ();

        restart_button.clicked.connect (() => {
            print("restarting..");
            restart_button.sensitive = false;
            restart_button.label = "Restarting...";
            ScreenManager.show_toast_with_content("Restarting ...", 2);
            
            state.container_restart.begin (container, (_, res) => {
                try {
                    state.container_restart.end (res);
                } catch (Docker.ApiClientError error) {
                    ScreenManager.show_toast_with_content("There was a problem restarting the container", 3);
                } finally {
                    restart_button.sensitive = true;
                }
            });
        });

        return restart_button;
    }

    private Gtk.Button create_remove_button(DockerContainer container){
        var remove_button = new Gtk.Button.with_label("Remove");
        var state = State.Root.get_instance ();

        remove_button.clicked.connect (() => {
            var dialog = new Adw.AlertDialog("Confirm Removal","Are you sure you want to remove this container?");
            dialog.add_response("cancel", "Cancel");
            dialog.add_response("confirm", "Remove");
            dialog.set_default_response("cancel");
            dialog.set_response_appearance("confirm", Adw.ResponseAppearance.DESTRUCTIVE);

            dialog.response.connect((response) => {
                if (response == "confirm") {
                    print("removing..");
                    remove_button.sensitive = false;
                    remove_button.label = "Removing...";
                    ScreenManager.show_toast_with_content("Removing ...", 2);
                    
                    state.container_remove.begin (container, (_, res) => {
                        try {
                            state.container_remove.end (res);
                        } catch (Docker.ApiClientError error) {
                            ScreenManager.show_toast_with_content("There was a problem removing the container", 3);
                        } finally {
                            remove_button.sensitive = true;
                        }
                    });
                }
                dialog.close();
            });
            menu_button.popover.closed();
            dialog.present(remove_button);
        });

        return remove_button;
    }
}