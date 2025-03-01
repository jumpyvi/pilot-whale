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