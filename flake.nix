{
  description = "DonQ's shared Nix modules";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

    # nix-darwin.url = "github:LnL7/nix-darwin";
    # nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # home-manager.url = "github:nix-community/home-manager/release-24.05";
    # home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {nixpkgs, ...}: let
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
  };
}
