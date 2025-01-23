newwhaler_sources = [
  'main.vala',
  'application.vala',
  'window.vala',
  'Widgets/ScreenManager.vala',
]

newwhaler_deps = [
  config_dep,
  dependency('gtk4'),
  dependency('libadwaita-1', version: '>= 1.4'),
]

newwhaler_sources += gnome.compile_resources('newwhaler-resources',
  'newwhaler.gresource.xml',
  c_name: 'newwhaler'
)

executable('newwhaler', newwhaler_sources,
  dependencies: newwhaler_deps,
  include_directories: config_inc,
       install: true,
)
