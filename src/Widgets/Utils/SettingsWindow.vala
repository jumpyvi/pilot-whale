/*
   This file is part of Whaler.

   Whaler is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License
   as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
   Whaler is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
   of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

   You should have received a copy of the GNU General Public License along with Whaler. If not, see <https://www.gnu.org/licenses/>.
 */
using Utils.Constants;

class Widgets.Utils.SettingsWindow : Adw.PreferencesDialog {
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
			title = _("API socket path"),
			show_apply_button = true,
      tooltip_text = "Usally /run/docker.sock or /var/run/docker.sock"
		};

     settings.bind ("docker-api-socket-path", docker_sock_entry, "text", SettingsBindFlags.DEFAULT);


    var docker_group = new Adw.PreferencesGroup ();
		docker_group.title = _("Docker");

		var docker_socket_row = new Adw.ActionRow ();
		docker_socket_row.activatable = false;
		docker_socket_row.title = _("Docker Socket");
		docker_socket_row.subtitle = _("/var/run/docker.sock");
    docker_socket_row.set_child(docker_sock_entry);
		docker_group.add (docker_socket_row);
  
    var privacy_group = new Adw.PreferencesGroup ();
		privacy_group.title = _("Privacy");

		var privacy_policy_row = new Adw.ActionRow ();
		privacy_policy_row.activatable = false;
		privacy_policy_row.title = _("Privacy Policy");
		privacy_policy_row.subtitle = _("We collect absolutely nothing");
		privacy_group.add (privacy_policy_row);


  page.add(docker_group);
	page.add (privacy_group);

  
  return page;
}