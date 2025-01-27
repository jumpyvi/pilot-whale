newwhaler_sources = [
  'main.vala',
  'application.vala',
  'window.vala',
  'Widgets/ScreenManager.vala',
  'Widgets/ScreenError.vala',
  'Widgets/Utils/SettingsWindow.vala',
  'Utils/HttpClient.vala',
]

newwhaler_deps = [
  config_dep,
  dependency('gtk4'),
  dependency('libadwaita-1', version: '>= 1.4'),
  dependency('libadwaita-1', version: '>= 1.4'),
  dependency('gio-2.0'),
  meson.get_compiler('vala').find_library('posix'),
  meson.get_compiler('vala').find_library('libcurl', dirs: vapi_dir),
  meson.get_compiler('c').find_library('libcurl', dirs: vapi_dir),
]

newwhaler_sources += gnome.compile_resources('newwhaler-resources', 'newwhaler.gresource.xml', c_name: 'newwhaler')

executable(
  'newwhaler',
  newwhaler_sources,
  dependencies: newwhaler_deps,
  include_directories: config_inc,
  install: true,
)