{
  description = "DonQ's shared Nix modules";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {self, ...}: {
    modules = {
      darwin = ./modules/darwin.nix;
    };

    templates.default = {
      path = ./template;
      description = "DonQ's workstation configuration template";
      welcomeText = ''
        # Welcome to DonQ's workstation configuration template

        ## Getting started

        ...

        ## Usage

        ...
      '';
    };
  };
}
