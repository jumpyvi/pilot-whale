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

sources += [
  # Main
  'src/main.vala',
  'src/application.vala',
  'src/window.vala',

  # Widgets
  'src/Widgets/ScreenMain.vala',
  'src/Widgets/ScreenManager.vala',
  'src/Widgets/ScreenError.vala',
  'src/Widgets/ScreenDockerContainer.vala',
  'src/Widgets/Utils/DockerContainerStatusLabel.vala',
  'src/Widgets/Utils/ReloadButton.vala',
  'src/Widgets/Utils/PullButton.vala',
  'src/Widgets/Utils/ImagesSearchButton.vala',
  'src/Widgets/Utils/BackButton.vala',
  'src/Widgets/Utils/ContainerInfoDialog.vala',
  'src/Widgets/Utils/ImagesSearchBar.vala',
  'src/Widgets/Utils/ImageCard.vala',

  'src/Widgets/Utils/ActionMenu.vala',
  'src/Widgets/Utils/MainAction.vala',

  'src/Widgets/Screens/Main/ContainersGrid.vala',
  'src/Widgets/Screens/Main/ContainersGridFilter.vala',
  'src/Widgets/Screens/Main/ContainerCard.vala',
  'src/Widgets/Screens/Main/ContainerCardActions.vala',

  'src/Widgets/Screens/DockerContainer/LogViewer.vala',
  'src/Widgets/Screens/DockerContainer/TopBar.vala',
  'src/Widgets/Screens/DockerContainer/TopBarActions.vala',
  'src/Widgets/Screens/DockerContainer/SideBarItem.vala',
  'src/Widgets/Screens/DockerContainer/SideBar.vala',
  'src/Widgets/Screens/DockerContainer/SideBarSeparator.vala',

  # Dialogs
  'src/Widgets/Dialogs/ImagesSearchDialog.vala',
  'src/Widgets/Dialogs/SettingsWindow.vala',

  # Utils
  'src/Utilities/HttpClient.vala',
  'src/Utilities/DockerContainer.vala',
  'src/Utilities/Helpers.vala',
  'src/Utilities/Reloader.vala',
  'src/Utilities/ActionHandler.vala',

  # Utils/Sorting
  'src/Utilities/Sorting/SortingInterface.vala',
  'src/Utilities/Sorting/SortingName.vala',
  'src/Utilities/Sorting/SortingStatus.vala',
  'src/Utilities/Sorting/SortingType.vala',

  # Docker
  'src/Docker/ApiClient.vala',
  'src/Docker/ContainerLogWatcher.vala',

  # States
  'src/State/Root.vala',
  'src/State/ScreenMain.vala',
  'src/State/ScreenDockerContainer.vala',
]

sources += gnome.compile_resources('pilotwhale-resources', 'pilot-whale.gresource.xml', c_name: 'pilotwhale')




