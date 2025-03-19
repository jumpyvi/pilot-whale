sources += configure_file(
  input: 'Utilities/Constants.vala.in',
  output: 'Constants.vala',
  configuration: configuration,
)

sources += configure_file(
    input : 'Build.vala.in',
    output : 'Build.vala',
    configuration : configuration
)

sources += files([
  # Main
  'application.vala',
  'window.vala',

  # States
  'State/Root.vala',
  'State/ScreenMainState.vala',
  'State/ScreenDockerContainerState.vala',

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
])

sources += gnome.compile_resources('pilotwhale-resources', 'pilot-whale.gresource.xml', c_name: 'pilotwhale')

sources_with_main = sources + files(['main.vala'])




