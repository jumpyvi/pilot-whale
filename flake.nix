{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
  let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
  in
  {
    devShells."<system>".default = with pkgs; mkShell {
      packages = [
        meson
        vala
        pkg-config
        ninja
        python3
        makeWrapper
        gtk4
        libadwaita
        json-glib
        libgee
        desktop-file-utils
        curl.dev
      ];
    };

    packages.x86_64-linux.default = with pkgs;
      stdenv.mkDerivation {
        pname = "pilot-whale";
        version = "4.2.3";

        src = fetchFromGitHub {
          owner = "Dralexgon";
          repo = "pilot-whale";
          rev = "master";
          sha256 = "sha256-citc8pHMkeUMKDj/WSeZVEMU+nWuELjnPMNCiNwD9XI=";
        };

        meta = with lib; {
          description = "Whaler is a tool to manage your Docker containers and images with a graphical interface.";
          platforms = platforms.linux;
        };

        nativeBuildInputs = [
          meson
          vala
          pkg-config
          ninja
          python3
          glib
          desktop-file-utils
          wrapGAppsHook4 # Fix glib schemas
        ];

        buildInputs = [
          gtk4
          libadwaita
          json-glib
          libgee
          curl.dev
        ];

        # Build the application with meson by default
      }
    ;
  };
}

