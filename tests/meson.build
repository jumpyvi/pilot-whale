sources = files(
  'ApiClient.test.vala',
)

test_unit = 'unit-test'

exe = executable(test_unit, sources: sources, dependencies : pilotwhale_deps)
test(test_unit, exe)