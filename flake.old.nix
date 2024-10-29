{
  description = "DonQ's Workstations Nix Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    nix-homebrew.inputs.nixpkgs.follows = "nixpkgs";
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

  outputs = {
    self,
    nixpkgs,
    home-manager,
    disko,
    nix-darwin,
    nix-homebrew,
    ...
  } @ inputs: let
    inherit (self) outputs;

    hostDirs = builtins.filter (dir: dir != "_base") (builtins.attrNames (builtins.readDir ./hosts));
    generateDarwinConfigurations =
      map
      (host: {
        name = host;
        value = nix-darwin.lib.darwinSystem {
          specialArgs = {inherit inputs;};
          modules = [
            ./hosts/${host}/main.nix
            home-manager.darwinModules.home-manager
            nix-homebrew.darwinModules.nix-homebrew
          ];
        };
      })
      hostDirs;
  in {
    darwinConfigurations = builtins.listToAttrs generateDarwinConfigurations;
  };
}
