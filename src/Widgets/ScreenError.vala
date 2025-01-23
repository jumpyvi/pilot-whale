/*
   This file is part of Whaler.

   Whaler is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License
   as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
   Whaler is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
   of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

   You should have received a copy of the GNU General Public License along with Whaler. If not, see <https://www.gnu.org/licenses/>.
 */

using Gtk;

class Widgets.ScreenError : Gtk.Grid {
    public static string CODE = "error";

    public ScreenError () {
        this.get_style_context ().add_class ("screen-error");
        this.valign = Gtk.Align.CENTER;
        this.halign = Gtk.Align.CENTER;
    }

    //  public void show_error (string error, string description) {
    //      this.foreach ((child) => {
    //          this.remove (child);
    //      });

    //      var alert = new Granite.Widgets.AlertView (error, description, "dialog-error");
    //      alert.get_style_context ().add_class ("alert");
    //      this.add (alert);

    //      this.show_all ();
    //  }

    public void show_widget (Adw.AlertDialog widget) {
        // todo - remove all child

        widget.present (this);
        this.attach (widget, 0, 0, 10, 10);
    }

    public static Adw.AlertDialog build_error_docker_not_avialable (bool no_entry) {
        var description = _ (
            "It looks like Docker requires root rights to use it. Thus, the application " +
            "cannot connect to Docker Engine API. Find out how to run docker without root " +
            "rights in <a href=\"https://docs.docker.com/engine/install/linux-postinstall/" +
            "\">Docker Manuals</a>, otherwise the application cannot work correctly. " +
            "Or check your socket path to Docker API in Settings."
        );

        if (no_entry) {
            description = _ (
                "It looks like Docker is not installed on your system. " +
                "To find out how to install it, see <a href=\"https://docs.docker.com/engine/" +
                "install/\">Docker Manuals</a>. " +
                "Or check your socket path to Docker API in Settings."
            );
        }

        var alert = new Adw.AlertDialog ("The app cannot connect to Docker API", description);

        //alert.show_action (_ ("Open settings")); // todo - make it so a button apears to open settings in the dialog

        return alert;
    }
}
