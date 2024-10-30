{
  description = "DonQ's shared Nix modules";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

    # nix-darwin.url = "github:LnL7/nix-darwin";
    # nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # home-manager.url = "github:nix-community/home-manager/release-24.05";
    # home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  }: let
    system = "aarch64-darwin";
    pkgs = import nixpkgs {inherit system;};
  in {
    darwinModules = {
      default = {...}: {
        environment.systemPackages = [pkgs.cowsay];
      };
    };
    homeManagerModules = {
      default = {...}: {
        home.packages = [pkgs.lolcat];
      };
    };

    templates.default = {
      path = ./template;
      description = "DonQ's workstation configuration template";
    };

    packages.${system}.templater = pkgs.writeShellApplication {
      name = "templater";
      runtimeInputs = [pkgs.gnused];
      text = ''
        sed -e "s/HOST_NAME/$1/g" -e "s/USER_NAME/$2/g" ${self}/template/flake.nix > "$3"
      '';
    };

    # USAGE: nix run .#templater -- hostname username path/to/output/flake.nix
    apps.interpolate = {
      type = "app";
      program = "${self.packages.${system}.templater}/bin/templater";
    };
  };
}
