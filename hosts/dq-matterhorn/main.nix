{ config, pkgs, ... }:

{
  nixpkgs.hostPlatform = "aarch64-darwin";

  imports = [
    ../_base/nix-homebrew.nix
    ../_base/homebrew.nix
    home-manager.darwinModules.home-manager
  ];

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    users."mrbash".imports = [
      ../_base/home.nix
      # ../../users/mrbash/interactive.nix
      # ../../users/mrbash/dq-matterhorn.nix
    ];
  };
}
