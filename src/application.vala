/*
   This file is part of Pilot Whale, a fork of Whaler by sdv43.

   Whaler is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License
   as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
   Whaler is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
   of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

   You should have received a copy of the GNU General Public License along with Whaler. If not, see <https://www.gnu.org/licenses/>.

   This fork, Pilot Whale, was created and modified by jumpyvi in 2025.
 */

using Widgets;


public class PilotWhale.Application : Adw.Application {
    public Application () {
        Object (
            application_id: "com.github.jumpyvi.pilot-whale",
            flags: ApplicationFlags.DEFAULT_FLAGS
        );
    }

    construct {
        ActionEntry[] action_entries = {
            { "about", this.on_about_action },
            { "preferences", this.on_preferences_action },
            { "quit", this.quit }
        };
        this.add_action_entries (action_entries, this);
        this.set_accels_for_action ("app.quit", {"<primary>q"});

    }

    public override void activate () {
        base.activate ();
        var win = this.active_window ?? new PilotWhale.Window (this);

        // --- Error Widget test --- //
        //var error_widget = ScreenError.build_error_docker_not_avialable (
        //                false
        //            );
        //
        //            ScreenManager.screen_error_show_widget (error_widget); 

        var provider = new Gtk.CssProvider ();
		provider.load_from_resource ("/com/github/jumpyvi/pilot-whale/index.css");

        // Nothing has replaced this yet, will need to be update when gtk5 releases
		Gtk.StyleContext.add_provider_for_display (
			Gdk.Display.get_default (), provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
			);
        win.present ();
        State.Root.get_instance ().init.begin ();
    }

    private void on_about_action () {
        var about = new Adw.AboutDialog () {
            application_name = "Pilot Whale",
            application_icon = "com.github.jumpyvi.pilot-whale",
            developer_name = "Pilot Whale Developpers",
            translator_credits = _("translator-credits"),
            version = Build.VERSION,
            license_type = Gtk.License.GPL_3_0,
            issue_url = "https://github.com/jumpyvi/pilot-whale/issues",
        };
        about.add_credit_section ("Original code from Whaler", {"sdv43"});
        about.add_credit_section ("The Pilot Whale fork (this)", {"jumpyvi"});
        about.add_link ("Get source code", "https://github.com/jumpyvi/pilot-whale");
        about.add_link ("Get original project", "https://www.github.com/sdv43/whaler");

        about.present (this.active_window);
    }

    private void on_preferences_action () {
        message ("app.preferences action activated");
        
        var setting_page = new Widgets.Dialogs.SettingsWindow();
        setting_page.present (this.active_window);

    }
}
