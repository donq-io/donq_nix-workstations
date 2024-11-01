{
  description = "DonQ's workstation configuration template";

  inputs = {
    donq.url = "github:donq-io/donq_nix-workstations";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-24.05";
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
      homeStateVersion = "24.05";
      systemStateVersion = 5;
    in
    {
      darwinConfigurations = {
        "HOSTNAME" = nix-darwin.lib.darwinSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            {
              system.stateVersion = systemStateVersion;
              nixpkgs.hostPlatform = "PLATFORM";
              users.users."USERNAME".home = "/Users/USERNAME";
            }
            donq.darwinModules."PLATFORM".default
            # ./custom-darwin-module.nix
            home-manager.darwinModules.home-manager
            {
              home-manager = {
                extraSpecialArgs = { inherit inputs outputs; };
                useGlobalPkgs = true;
                useUserPackages = true;
                users."USERNAME".imports = [
                  { home.stateVersion = homeStateVersion; }
                  donq.homeManagerModules."PLATFORM".default
                  # ./custom-homemanager-module.nix
                ];
              };
            }
          ];
        };
      };
    };
}
