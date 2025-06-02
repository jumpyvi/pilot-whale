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
          sha256 = "sha256-B5JDHSgvoA+YAov/GOJkNXMiex0ZY9HVJOgfyUlpZwY=";
        };

        nativeBuildInputs = [
          meson
          vala
          pkg-config
          ninja
          python3
          makeWrapper
        ];
        buildInputs = [
          gtk4
          libadwaita
          json-glib
          libgee
          desktop-file-utils
          curl.dev
        ];

        meta = with lib; {
          description = "Whaler is a tool to manage your Docker containers and images with a graphical interface.";
          platforms = platforms.linux;
        };

        postInstall = ''
          echo "Recompiling GSettings schemas for runtime use..."
          glib-compile-schemas $out/share/glib-2.0/schemas
          echo "Path to GSettings schemas: $out/share/gsettings-schemas/$name"
          wrapProgram "$out/bin/com.github.sdv43.whaler" --prefix XDG_DATA_DIRS : $out/share
        '';
      }
    ;
  };
}

