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

class Utilities.ActionHandler {
    public static void handle(Gtk.Widget widget, DockerContainer container) {
        button_main_action_handler.begin (container, (_, res) => {
                button_main_action_handler.end (res);
                widget.sensitive = true;
        });
    }

    private static async void button_main_action_handler (DockerContainer container) {
        var state = State.Root.get_instance ();
        var err_msg = _ ("Container action error");

        try {
            switch (container.state) {
                case DockerContainerState.RUNNING:
                    err_msg = _ ("Container stop error");
                    ScreenManager.show_toast_with_content ("Stopping Container...", 3);
                    yield state.container_stop(container);
                    break;

                case DockerContainerState.STOPPED:
                    err_msg = _ ("Container start error");
                    ScreenManager.show_toast_with_content ("Starting Container...", 3);
                    yield state.container_start(container);
                    break;

                case DockerContainerState.PAUSED:
                    err_msg = _ ("Container unpause error");
                    ScreenManager.show_toast_with_content ("Pausing Container...", 3);
                    yield state.container_unpause(container);
                    break;

                case DockerContainerState.UNKNOWN:
                    var error_widget = new Adw.AlertDialog (err_msg, _ ("Container state is unknown"));
                    ScreenManager.screen_error_show_widget (error_widget);
                    break;
            }
        } catch (Docker.ApiClientError error) {
            var error_widget = new Adw.AlertDialog (err_msg, error.message);
            ScreenManager.screen_error_show_widget (error_widget);
        }

        Reloader.reload ();
    }


}