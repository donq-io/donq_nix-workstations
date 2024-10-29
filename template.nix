{
  description = "DonQ's workstation configuration template";

  inputs = {
    donq.url = "github:donq-io/donq_nix-workstations";

    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    # nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    #
    # home-manager.url = "github:nix-community/home-manager/release-24.05";
    # home-manager.inputs.nixpkgs.follows = "nixpkgs";
    #
    # nix-darwin.url = "github:LnL7/nix-darwin";
    # nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    #
    # nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    # nix-homebrew.inputs.nixpkgs.follows = "nixpkgs";
    # homebrew-core = {
    #   url = "github:homebrew/homebrew-core";
    #   flake = false;
    # };
    # homebrew-cask = {
    #   url = "github:homebrew/homebrew-cask";
    #   flake = false;
    # };
    # homebrew-bundle = {
    #   url = "github:homebrew/homebrew-bundle";
    #   flake = false;
    # };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nix-darwin,
    donq,
    # nix-homebrew,
    ...
  } @ inputs: let
    inherit (self) outputs;
  in {
    overlays = import ./overlays {inherit inputs;};

    darwinConfigurations = {
      "ebisu" = nix-darwin.lib.darwinSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          {nixpkgs.hostPlatform = "aarch64-darwin";}
          donq.modules.darwin
          # ({outputs, ...}: {
          #   nixpkgs.overlays = [
          #     outputs.overlays.unstable-packages
          #   ];
          # })
          # my sys config here
          # ./hosts/ebisu/configuration.nix
          # nix-homebrew.darwinModules.nix-homebrew
          # ./hosts/ebisu/nix-homebrew.nix
          # ./hosts/ebisu/homebrew.nix
          # home-manager.darwinModules.home-manager
          # {
          #   home-manager = {
          #     extraSpecialArgs = {inherit inputs outputs;};
          #     useGlobalPkgs = true;
          #     useUserPackages = true;
          #     users."Brasolin".imports = [
          #       # donq stuff here
          #       # ./hosts/ebisu/home.nix
          #       # ./users/paolo/agda.nix
          #     ];
          #   };
          # }
        ];
      };
    };
  };
}
