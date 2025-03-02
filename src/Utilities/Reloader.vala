/*
   This file is part of Bubbler, a fork of Whaler by sdv43.

   Whaler is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License
   as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
   Whaler is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
   of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

   You should have received a copy of the GNU General Public License along with Whaler. If not, see <https://www.gnu.org/licenses/>.

   This fork, Bubbler, was created and modified by jumpyvi in 2025.
 */

public class Utilities.Reloader {
    public static void reload (){
        var state = State.Root.get_instance ();
        state.containers_load.begin ((_, res) => {
                try {
                    state.containers_load.end (res);

                    if (state.active_screen == Widgets.ScreenError.CODE) {
                        state.active_screen = Widgets.ScreenMain.CODE;
                    }
                } catch (Docker.ApiClientError error) {
                    var error_widget = Widgets.ScreenError.build_error_docker_not_avialable (
                        error is Docker.ApiClientError.ERROR_NO_ENTRY
                    );

                    Widgets.ScreenManager.screen_error_show_widget (error_widget);
                }
            });
    }
}