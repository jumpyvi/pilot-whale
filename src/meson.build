configuration = configuration_data()

configuration.set_quoted('APP_ID', meson.project_name())
configuration.set_quoted('APP_VERSION', meson.project_version())
configuration.set_quoted('LOCALE_DIR', join_paths(get_option('prefix'), get_option('localedir')))

constants = configure_file(
  input: 'Utils/Constants.vala.in',
  output: 'Constants.vala',
  configuration: configuration,
)

newwhaler_sources = [
  # Main
  'main.vala',
  'application.vala',
  'window.vala',

  # Widgets
  'Widgets/ScreenMain.vala',
  'Widgets/ScreenManager.vala',
  'Widgets/ScreenError.vala',
  'Widgets/Utils/SettingsWindow.vala',
  'Widgets/Utils/DockerContainerStatusLabel.vala',

  'Widgets/Screens/Main/ContainersGrid.vala',
  'Widgets/Screens/Main/ContainersGridFilter.vala',
  'Widgets/Screens/Main/ContainerCard.vala',
  'Widgets/Screens/Main/ContainerCardActions.vala',

  # Utils
  'Utils/HttpClient.vala',
  'Utils/DockerContainer.vala',
  'Utils/Helpers.vala',

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

newwhaler_deps = [
  config_dep,
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

newwhaler_sources += gnome.compile_resources('newwhaler-resources', 'newwhaler.gresource.xml', c_name: 'newwhaler')

executable(
  'newwhaler',
  constants,
  newwhaler_sources,
  dependencies: newwhaler_deps,
  include_directories: config_inc,
  install: true,
)