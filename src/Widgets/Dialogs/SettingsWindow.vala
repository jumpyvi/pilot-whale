/*
   This file is part of Bubbler, a fork of Whaler by sdv43.

   Whaler is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License
   as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
   Whaler is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
   of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

   You should have received a copy of the GNU General Public License along with Whaler. If not, see <https://www.gnu.org/licenses/>.

   This fork, Bubbler, was created and modified by jumpyvi in 2025.
 */

using Utilities.Constants;

class Widgets.Dialogs.SettingsWindow : Adw.PreferencesDialog {
    public SettingsWindow(){
        Object(
          content_width: 450,
          content_height: 600
        );
    }

    construct {
      add (get_pref());
    }
}

private Adw.PreferencesPage get_pref(){
    var page = new Adw.PreferencesPage();
    page.title = "Preferences";
    page.name = "preferences";

    var settings = new Settings(APP_ID);
    
    var docker_sock_entry = new Adw.EntryRow () {
        title = _( "API socket path" ),
        show_apply_button = true,
        tooltip_text = "Usually /run/docker.sock or /var/run/docker.sock"
    };

    settings.bind("docker-api-socket-path", docker_sock_entry, "text", SettingsBindFlags.DEFAULT);

    var check_button = new Gtk.Button.with_label (_("Check connection"));
    check_button.margin_top = 10;
    check_button.halign = Gtk.Align.BASELINE_CENTER;
    check_button.clicked.connect (() => {
        check_button.sensitive = false;
        check_socket_connection.begin(docker_sock_entry.text, check_button);
    });

    var docker_group = new Adw.PreferencesGroup();
    docker_group.title = _( "Docker" );

    var docker_socket_row = new Adw.ActionRow();
    docker_socket_row.activatable = false;
    docker_socket_row.title = _( "Docker Socket" );
    docker_socket_row.subtitle = _( "/var/run/docker.sock" );
    docker_socket_row.set_child(docker_sock_entry);
    docker_group.add(docker_socket_row);
    docker_group.add(check_button);

    var version_label = new Gtk.Label("");
    docker_group.add(version_label);

    var privacy_group = new Adw.PreferencesGroup();
    privacy_group.title = _( "Privacy" );

    var privacy_policy_row = new Adw.ActionRow();
    privacy_policy_row.activatable = false;
    privacy_policy_row.title = _( "Privacy Policy" );
    privacy_policy_row.subtitle = _( "Blubber collects absolutely nothing. \nDockerHub, registries and pulled images might." );
    privacy_group.add(privacy_policy_row);

    page.add(docker_group);
    page.add(privacy_group);
    
    return page;
}

private async void check_socket_connection(string socket_path, Gtk.Button button) {
    var api_client = new Docker.ApiClient();
    button.remove_css_class("success");
    button.remove_css_class("error");
    try {
        api_client.http_client.unix_socket_path = socket_path;
        yield api_client.ping();

        var docker_version_info = yield api_client.version();
        var engine = socket_path.contains("podman.sock") ? "Podman" : "Docker";
        button.label = _("Connection Successful: %s v%s, API v%s").printf(engine, docker_version_info.version, docker_version_info.api_version);
        button.add_css_class("success");
    } catch (Docker.ApiClientError error) {
        button.label = _( "Connection Failed" );
        button.add_css_class("error");
    } finally {
        button.sensitive = true;
    }
}
