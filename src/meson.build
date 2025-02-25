configuration = configuration_data()
configuration.set_quoted('GETTEXT_PACKAGE', 'whaler')
configuration.set_quoted('APPLICATION_ID', 'com.github.sdv43.whaler')
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
  input: 'Utils/Constants.vala.in',
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
  'Widgets/Utils/SettingsWindow.vala',
  'Widgets/Utils/DockerContainerStatusLabel.vala',
  'Widgets/Utils/ReloadButton.vala',
  'Widgets/Utils/ContainerPullButton.vala',
  'Widgets/Utils/BackButton.vala',
  'Widgets/Utils/ContainerInfoDialog.vala',
  'Widgets/Utils/ContainerPullSearchBar.vala',

  'Widgets/Utils/ActionMenu.vala',
  'Widgets/Utils/MainAction.vala',

  'Widgets/Screens/Main/ContainersGrid.vala',
  'Widgets/Screens/Main/ContainersGridFilter.vala',
  'Widgets/Screens/Main/ContainerCard.vala',
  'Widgets/Screens/Main/ContainerCardActions.vala',

  'Widgets/Screens/Main/DockerContainer/LogViewer.vala',
  'Widgets/Screens/Main/DockerContainer/TopBar.vala',
  'Widgets/Screens/Main/DockerContainer/TopBarActions.vala',
  'Widgets/Screens/Main/DockerContainer/SideBarItem.vala',
  'Widgets/Screens/Main/DockerContainer/SideBar.vala',
  'Widgets/Screens/Main/DockerContainer/SideBarSeparator.vala',

  # Dialogs
  'Widgets/Dialogs/ContainerPullDialog.vala',

  # Utils
  'Utils/HttpClient.vala',
  'Utils/DockerContainer.vala',
  'Utils/Helpers.vala',
  'Utils/Reloader.vala',
  'Utils/ActionHandler.vala',

  # Utils/Sorting
  'Utils/Sorting/SortingInterface.vala',
  'Utils/Sorting/SortingName.vala',
  'Utils/Sorting/SortingStatus.vala',
  'Utils/Sorting/SortingType.vala',

  # Docker
  'Docker/ApiClient.vala',
  'Docker/ContainerLogWatcher.vala',

  # States
  'State/Root.vala',
  'State/ScreenMain.vala',
  'State/ScreenDockerContainer.vala',
]




whaler_deps = [
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

sources += gnome.compile_resources('whaler-resources', 'whaler.gresource.xml', c_name: 'whaler')

sources += configure_file(
    input : 'Build.vala.in',
    output : 'Build.vala',
    configuration : configuration
)

executable(
  meson.project_name(),
  constants,
  sources,
  dependencies: whaler_deps,
  install: true,
)

