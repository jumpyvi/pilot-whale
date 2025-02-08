/*
 * This file is part of Whaler.
 * Whaler is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 * Whaler is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
 * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 * You should have received a copy of the GNU General Public License along with Whaler. If not, see <https://www.gnu.org/licenses/>.
 */

public class Widgets.ScreenManager : Gtk.Box {
    private static ScreenManager? instance;
    private ScreenError screen_error;
    private Adw.ToastOverlay toast_overlay;


    construct {
        var state = State.Root.get_instance ();
        this.orientation = Gtk.Orientation.VERTICAL;

        this.toast_overlay = new Adw.ToastOverlay ();
              
        this.screen_error = new ScreenError ();

        var stack = new Gtk.Stack ();
        stack.transition_type = Gtk.StackTransitionType.OVER_LEFT_RIGHT;
        stack.transition_duration = 300;

        stack.add_named (new ScreenMain (), ScreenMain.CODE);
        stack.add_named (this.screen_error, ScreenError.CODE);
        
        stack.add_named (new ScreenDockerContainer (), ScreenDockerContainer.CODE); 

        stack.show.connect (() => {
            stack.set_visible_child_name (state.active_screen);
        });

        state.notify["active-screen"].connect (() => {
            stack.set_visible_child_name (state.active_screen);
        });
        this.append (stack);
        this.append (toast_overlay);
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

    public static void show_toast_with_content (string content, uint timeout){
        Adw.Toast toast = new Adw.Toast (content);
        toast.set_timeout (timeout);
        instance.toast_overlay.add_toast (toast);
    }


    public static void screen_error_show_widget (Adw.AlertDialog widget) {
        widget.add_response ("dismiss", "Dismiss");

        instance.screen_error.show_widget (widget);
        //State.Root.get_instance ().active_screen = ScreenError.CODE;
    }
}
