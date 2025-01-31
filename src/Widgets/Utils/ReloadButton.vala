/*
 * This file is part of Whaler.
 * Whaler is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 * Whaler is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
 * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 * You should have received a copy of the GNU General Public License along with Whaler. If not, see <https://www.gnu.org/licenses/>.
 */
 public class Widgets.Utils.ReloadButton : Gtk.Button {
    private Adw.ButtonContent button_content = new Adw.ButtonContent ();
    private static ReloadButton? instance;
    private const string BUTTON_ICON_NAME = "view-refresh-symbolic";
    private const string TOOLTIP_CONTENT = "Refresh";

    construct{
        var state = State.Root.get_instance ();
        button_content.set_icon_name (BUTTON_ICON_NAME);
        button_content.set_tooltip_text (TOOLTIP_CONTENT);
        this.set_child (button_content);
        

        this.clicked.connect ((button) => {
            this.add_css_class ("refresh-animation");
            this.set_sensitive (false);

            Timeout.add (600, () => {
               this.remove_css_class ("refresh-animation");
                this.set_sensitive (true);
                return false;
            }, Priority.LOW);

            state.containers_load.begin ((_, res) => {
                try {
                    state.containers_load.end (res);

                    if (state.active_screen == ScreenError.CODE) {
                        state.active_screen = ScreenMain.CODE;
                    }
                } catch (Docker.ApiClientError error) {
                    var error_widget = ScreenError.build_error_docker_not_avialable (
                        error is Docker.ApiClientError.ERROR_NO_ENTRY
                    );

                    ScreenManager.screen_error_show_widget (error_widget);
                }
            });
        });

        this.show.connect (() => {
            this.sensitive = state.active_screen == ScreenMain.CODE
                                       || state.active_screen == ScreenError.CODE;
        });

        state.notify["active-screen"].connect (() => {
            this.sensitive = state.active_screen == ScreenMain.CODE
                                       || state.active_screen == ScreenError.CODE;
        });
    }

    private  ReloadButton () {
        Object ();
    }

    public static ReloadButton get_instance () {
        if (ReloadButton.instance == null) {
            ReloadButton.instance = new ReloadButton ();
        }
        return ReloadButton.instance;
    }

 }