/*
 * This file is part of Whaler.
 * Whaler is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 * Whaler is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
 * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 * You should have received a copy of the GNU General Public License along with Whaler. If not, see <https://www.gnu.org/licenses/>.
 */

using Gtk;

public class Widgets.ScreenManager : Adw.Bin {
    private static ScreenManager? instance;
    private ScreenError screen_error;
    private Gtk.Revealer overlay_revealer;
    private Gtk.Label overlay_label;
    private bool overlay_bar_visible = false;
    private Gtk.Overlay overlay;


    construct {
        // var state = State.Root.get_instance (); // todo

        // Create overlay components
        this.overlay_revealer = new Gtk.Revealer ();
        this.overlay_label = new Gtk.Label ("");
        this.overlay = new Gtk.Overlay ();
        child = overlay;

        var overlay_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6) {
            margin_start = 12,
            margin_end = 12,
            margin_top = 12,
            margin_bottom = 12
        };
        
        overlay_box.add_css_class ("app-notification");
        overlay_box.append (this.overlay_label);
        
        this.overlay_revealer.child = overlay_box;
        this.overlay_revealer.transition_type = Gtk.RevealerTransitionType.SLIDE_UP;
        this.overlay_revealer.valign = Gtk.Align.END;
        this.overlay_revealer.halign = Gtk.Align.END;
        

        this.screen_error = new ScreenError ();

        var stack = new Gtk.Stack ();
        stack.transition_type = Gtk.StackTransitionType.OVER_LEFT_RIGHT;
        stack.transition_duration = 300;

        stack.add_named (this.screen_error, ScreenError.CODE);
        //  stack.add_named (new ScreenMain (), ScreenMain.CODE);
        //  stack.add_named (new ScreenDockerContainer (), ScreenDockerContainer.CODE); // todo

        //  stack.show.connect (() => {
        //      stack.set_visible_child_name (state.active_screen);
        //  });

        //  state.notify["active-screen"].connect (() => {
        //      stack.set_visible_child_name (state.active_screen);
        //  }); // todo

        overlay.show.connect (() => {
            this.overlay_revealer.reveal_child = this.overlay_bar_visible;
        });

        overlay.set_child (stack);
        overlay.add_overlay (this.overlay_revealer);
    }

    private ScreenManager () {
        Object ();
    }

    public static ScreenManager get_instance () {
        if (ScreenManager.instance == null) {
            ScreenManager.instance = new ScreenManager ();
        }
        return ScreenManager.instance;
    }

    public static void overlay_bar_show (string message, int delay = 1000) {
        instance.overlay_bar_visible = true;
        instance.overlay_label.label = message;
        instance.overlay_revealer.reveal_child = true;
        
        Timeout.add (delay, () => {
            instance.overlay_revealer.reveal_child = instance.overlay_bar_visible;
            return false;
        });
    }

    public static void overlay_bar_hide () {
        instance.overlay_bar_visible = false;
        instance.overlay_revealer.reveal_child = false;
    }

    public static void dialog_error_show (Gtk.Widget parent, string title, string description) {
        var dialog = new Adw.AlertDialog (
            title,
            description
        );
        dialog.add_response ("confirm", "OK");
        dialog.present (parent);
    }

    public static void screen_error_show_widget (Adw.AlertDialog widget) {
        instance.screen_error.show_widget (widget); // todo
        //State.Root.get_instance ().active_screen = ScreenError.CODE;
    }
}
