/* application.vala
 *
 * Copyright 2025 Whaler Developpers
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

using Widgets;

public class Whaler.Application : Adw.Application {
    public Application () {
        Object (
            application_id: "com.github.sdv43.whaler",
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
        var win = this.active_window ?? new Whaler.Window (this);

        // --- Error Widget test --- //
        //var error_widget = ScreenError.build_error_docker_not_avialable (
        //                false
        //            );
        //
        //            ScreenManager.screen_error_show_widget (error_widget); 

        var provider = new Gtk.CssProvider ();
		provider.load_from_resource ("/com/github/sdv43/whaler/index.css");

        // Nothing has replaced this yet, will need to be update when gtk5 releases
		Gtk.StyleContext.add_provider_for_display (
			Gdk.Display.get_default (), provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
			);

        win.set_child (ScreenManager.get_instance ());
        win.present ();
        State.Root.get_instance ().init.begin ();
    }

    private void on_about_action () {
        string[] developers = { "Whaler Developpers" };
        var about = new Adw.AboutDialog () {
            application_name = "whaler",
            application_icon = "com.github.sdv43.whaler",
            developer_name = "Whaler Developpers",
            translator_credits = _("translator-credits"),
            version = "0.1.0",
            developers = developers,
            copyright = "© 2025 Whaler Developpers",
        };

        about.present (this.active_window);
    }

    private void on_preferences_action () {
        message ("app.preferences action activated");
        
        var setting_page = new Widgets.Utils.SettingsWindow();
        setting_page.present (this.active_window);

    }
}
