project(
  'com.github.jumpyvi.pilot-whale',
  ['vala', 'c'],
  version: 'v4.2.3',
  meson_version: '>= 0.56.0',
  default_options: [
    'warning_level=2',
    'werror=false',
  ],
)

# Configuration files
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

add_project_arguments(['--vapidir=' + meson.project_source_root() / 'vapi'], language: 'vala')
add_project_arguments (
  '-DGETTEXT_PACKAGE="@0@"'.format(meson.project_name()),
  '-DG_LOG_DOMAIN="PilotWhale"',
  language: 'c'
)
gnome = import('gnome')
i18n = import('i18n')

sources = files()
subdir('src')

vapi_dir = meson.current_source_dir() / 'vapi'
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

executable(
  meson.project_name(),
  sources,
  dependencies: pilotwhale_deps,
  install: true,
)

subdir('tests')
subdir('data')
subdir('po')


gnome.post_install(
  glib_compile_schemas: true,
  gtk_update_icon_cache: true,
  update_desktop_database: true,
)