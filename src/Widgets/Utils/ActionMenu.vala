using Utils;
using Widgets;

class Widgets.Utils.ActionMenu : Adw.Bin {
    private Gtk.MenuButton menu_button;

    public ActionMenu(DockerContainer container) {
        menu_button = new Gtk.MenuButton ();
        menu_button.has_frame = false;
        menu_button.icon_name = "view-more-symbolic";
        menu_button.sensitive = true;
        menu_button.set_popover (build_menu (this, container));

        this.set_child (menu_button);
    }

    private Gtk.PopoverMenu build_menu (Gtk.Widget parent, DockerContainer container) {
        Gtk.PopoverMenu menu = new Gtk.PopoverMenu.from_model (build_menu_model());
        parent.insert_action_group ("container", create_actions (container));

        return menu;
    }

    private GLib.MenuModel build_menu_model () {
        Menu menu_content = new Menu ();
        menu_content.append ("Pause", "container.pause");
        menu_content.append ("Restart", "container.restart");
        menu_content.append ("Remove", "container.remove");
        menu_content.append ("Info", "container.info");

        return menu_content;
    }

    private SimpleActionGroup create_actions (DockerContainer container) {
        SimpleActionGroup action_group = new SimpleActionGroup ();
        var state = State.Root.get_instance ();

        // Pause action
        SimpleAction pause_action = new SimpleAction ("pause", null);
        pause_action.activate.connect ((parameter) => {
            var err_msg = "Cant pause";
            state.container_pause.begin (container, (_, res) => {
                try {
                    state.container_pause.end (res);
                } catch (Docker.ApiClientError error) {
                    // TODO - dialog
                    print ("pausing error");
                } finally {
                    // TODO - When the action is done, set the MenuButton to sensitive
                    print ("pausing success");
                }
            });
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
