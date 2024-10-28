{ inputs, config, pkgs, nix-homebrew, home-manager, ... }:
let
  user = "federico";
  hostname = "dq-matterhorn";
in
{
  nixpkgs.hostPlatform = "aarch64-darwin";

  imports = [
    (import ../_base/configuration.nix { inherit inputs pkgs user hostname; })
    (import ../_base/nix-homebrew.nix { inherit inputs nix-homebrew user; })
    ../_base/homebrew.nix
    {
      home-manager = {
        extraSpecialArgs = { inherit inputs; };
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "backup";
        users."${user}" = {
          imports = [
            ../_base/home.nix
          ];
        };
      };
    }
  ];
}
