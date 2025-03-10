configuration = configuration_data()
configuration.set_quoted('GETTEXT_PACKAGE', 'pilot-whale')
configuration.set_quoted('APPLICATION_ID', 'com.github.jumpyvi.pilot-whale')
configuration.set_quoted('VERSION', meson.project_version())
configuration.set_quoted('PREFIX', get_option('prefix'))
configuration.set_quoted('DATADIR', join_paths(get_option('prefix'), get_option('datadir')))
configuration.set_quoted('PROFILE', 'default')
configuration.set_quoted('LOCALEDIR', join_paths(get_option('prefix'), get_option('localedir')))
configuration.set_quoted('GNOMELOCALEDIR', join_paths(get_option('prefix'), get_option('localedir'), 'gnome'))

configuration.set_quoted('APP_ID', meson.project_name())
configuration.set_quoted('APP_VERSION', meson.project_version())
configuration.set_quoted('LOCALE_DIR', join_paths(get_option('prefix'), get_option('localedir')))

constants = configure_file(
  input: 'Utilities/Constants.vala.in',
  output: 'Constants.vala',
  configuration: configuration,
)



sources = [
  # Main
  'main.vala',
  'application.vala',
  'window.vala',

  # Widgets
  'Widgets/ScreenMain.vala',
  'Widgets/ScreenManager.vala',
  'Widgets/ScreenError.vala',
  'Widgets/ScreenDockerContainer.vala',
  'Widgets/Utils/DockerContainerStatusLabel.vala',
  'Widgets/Utils/ReloadButton.vala',
  'Widgets/Utils/PullButton.vala',
  'Widgets/Utils/ImagesSearchButton.vala',
  'Widgets/Utils/BackButton.vala',
  'Widgets/Utils/ContainerInfoDialog.vala',
  'Widgets/Utils/ImagesSearchBar.vala',
  'Widgets/Utils/ImageCard.vala',

  'Widgets/Utils/ActionMenu.vala',
  'Widgets/Utils/MainAction.vala',

  'Widgets/Screens/Main/ContainersGrid.vala',
  'Widgets/Screens/Main/ContainersGridFilter.vala',
  'Widgets/Screens/Main/ContainerCard.vala',
  'Widgets/Screens/Main/ContainerCardActions.vala',

  'Widgets/Screens/DockerContainer/LogViewer.vala',
  'Widgets/Screens/DockerContainer/TopBar.vala',
  'Widgets/Screens/DockerContainer/TopBarActions.vala',
  'Widgets/Screens/DockerContainer/SideBarItem.vala',
  'Widgets/Screens/DockerContainer/SideBar.vala',
  'Widgets/Screens/DockerContainer/SideBarSeparator.vala',

  # Dialogs
  'Widgets/Dialogs/ImagesSearchDialog.vala',
  'Widgets/Dialogs/SettingsWindow.vala',

  # Utils
  'Utilities/HttpClient.vala',
  'Utilities/DockerContainer.vala',
  'Utilities/Helpers.vala',
  'Utilities/Reloader.vala',
  'Utilities/ActionHandler.vala',

  # Utils/Sorting
  'Utilities/Sorting/SortingInterface.vala',
  'Utilities/Sorting/SortingName.vala',
  'Utilities/Sorting/SortingStatus.vala',
  'Utilities/Sorting/SortingType.vala',

  # Docker
  'Docker/ApiClient.vala',
  'Docker/ContainerLogWatcher.vala',

  # States
  'State/Root.vala',
  'State/ScreenMain.vala',
  'State/ScreenDockerContainer.vala',
]




pilotwhale_deps = [
  dependency('gtk4'),
  dependency('libadwaita-1', version: '>= 1.4'),
  dependency('libadwaita-1', version: '>= 1.4'),
  dependency('json-glib-1.0'),
  dependency('gio-2.0'),
  dependency('gee-0.8'),
  meson.get_compiler('vala').find_library('posix'),
  meson.get_compiler('vala').find_library('libcurl', dirs: vapi_dir),
  meson.get_compiler('c').find_library('libcurl', dirs: vapi_dir),
]

sources += gnome.compile_resources('pilotwhale-resources', 'pilot-whale.gresource.xml', c_name: 'pilotwhale')

sources += configure_file(
    input : 'Build.vala.in',
    output : 'Build.vala',
    configuration : configuration
)

executable(
  meson.project_name(),
  constants,
  sources,
  dependencies: pilotwhale_deps,
  install: true,
)

