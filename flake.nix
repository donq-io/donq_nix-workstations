{
  description = "DonQ's shared Nix modules";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-25.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";

    # Keep the Homebrew frontend in sync with the moving core/cask taps.
    brew-src = {
      url = "github:Homebrew/brew";
      flake = false;
    };

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    nix-homebrew.inputs.brew-src.follows = "brew-src";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
  };

  outputs =
    inputs @ { self
    , flake-utils
    , nixpkgs
    , nixpkgs-unstable
    , nix-homebrew
    , ...
    }:
    flake-utils.lib.eachSystem [ "aarch64-darwin" "x86_64-darwin" ]
      (
        system:
        let
          pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
          pkgs-unstable = import nixpkgs-unstable { inherit system; config.allowUnfree = true; };
        in
        {
          darwinModules = {
            default = { ... }: {
              nixpkgs.overlays = [
                (_final: _prev: { ruby_4_0 = (import nixpkgs-unstable { inherit system; }).ruby_4_0; })
              ];
              environment.systemPackages = [ pkgs.cowsay ];
              imports = [
                ((import ./shared/configuration.nix) { pkgs = pkgs; pkgs-unstable = pkgs-unstable; })
                nix-homebrew.darwinModules.nix-homebrew
                ((import ./shared/nix-homebrew.nix) { inputs = inputs; })
                (import ./shared/homebrew.nix)
              ];
            };
          };
          homeManagerModules = {
            default = { ... }: {
              imports = [ ((import ./shared/home.nix) { pkgs = pkgs; pkgs-unstable = pkgs-unstable; }) ];
            };
          };

          packages.templater = pkgs.writeShellApplication {
            name = "templater";
            runtimeInputs = [ pkgs.gnused ];
            text = ''
              flake_directory=$(dirname "$3")
              mkdir -p "$flake_directory"
              sed -e "s/USERNAME/$1/g" -e "s/PLATFORM/$2/g" ${self}/template/flake.nix > "$3"
            '';
          };

          # USAGE: nix run .#templater -- username platform path/to/output/flake.nix
          apps.templater = {
            type = "app";
            program = "${self.packages.${system}.templater}/bin/templater";
          };
        }
      )
    // {
      templates.default = {
        path = ./template;
        description = "DonQ's workstation configuration template";
      };
    };
}
