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

        Gtk.Button remove_action = new Gtk.Button.with_label("Remove");
        Gtk.Button info_action = new Gtk.Button.with_label("Info");
        action_box.append(create_pause_button(container));
        action_box.append(create_restart_button(container));
        action_box.append(remove_action);
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
                    print(error.message); // TODO - add GUI error
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
            var err_msg = _ ("Container restart error");
            restart_button.sensitive = false;
            restart_button.label = "Restarting...";
            ScreenManager.show_toast_with_content("Restarting ...", 2);
            
            state.container_restart.begin (container, (_, res) => {
                try {
                    state.container_restart.end (res);
                } catch (Docker.ApiClientError error) {
                    print(error.message); // TODO - add GUI error
                } finally {
                    restart_button.sensitive = true;
                }
            });
        });

        return restart_button;
    }
}