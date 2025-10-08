{
  description = "DonQ's workstation configuration template";

  inputs = {
    donq.url = "github:donq-io/donq_nix-workstations";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-25.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { self
    , donq
    , nixpkgs
    , nix-darwin
    , home-manager
    , ...
    } @ inputs:
    let
      inherit (self) outputs;
      homeStateVersion = "25.05";
      systemStateVersion = 1;
      username = "USERNAME";
      platform = "PLATFORM";
    in
    {
      darwinConfigurations = {
        default = nix-darwin.lib.darwinSystem {
          specialArgs = { inherit inputs outputs username platform homeStateVersion systemStateVersion; };
          modules = [
            {
              system.stateVersion = systemStateVersion;
              nixpkgs.hostPlatform = platform;
              users.users."${username}".home = "/Users/${username}";
            }
            donq.darwinModules."${platform}".default
            # ./custom-darwin-module.nix
            home-manager.darwinModules.home-manager
            {
              home-manager = {
                extraSpecialArgs = { inherit inputs outputs username platform homeStateVersion systemStateVersion; };
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "nix.old";
                users."${username}".imports = [
                  { home.stateVersion = homeStateVersion; }
                  donq.homeManagerModules."${platform}".default
                  # ./custom-homemanager-module.nix
                ];
              };
            }
          ];
        };
      };
    };
}
