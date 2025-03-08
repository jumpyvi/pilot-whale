constants = configure_file(
     input: meson.project_source_root() + '/src/Utilities/Constants.vala.in',
     output: 'Constants.vala',
     configuration: configuration,
)

unit_tests = {
        'ApiClient' : files (
            constants.full_path(),
            meson.project_source_root() + '/src/Utilities/HttpClient.vala',
            meson.project_source_root() + '/src/Docker/ApiClient.vala',
        )
}

foreach name, t_sources : unit_tests
    test(name, executable(name, name + '.test.vala', sources: t_sources, dependencies: pilotwhale_deps))
endforeach