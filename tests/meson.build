unit_test_files = [
    'ApiClient',
    'HttpClient',
    'Helpers',
    'Template'
]

foreach name : unit_test_files
    test(name, executable(name, name + '.test.vala', sources, dependencies: pilotwhale_deps))
endforeach