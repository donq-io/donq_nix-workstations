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
      username = "USERNAME";
      hostname = "HOSTNAME";
    in
    {
      darwinConfigurations = {
        "${hostname}" = nix-darwin.lib.darwinSystem {
          specialArgs = { inherit inputs outputs username hostname homeStateVersion systemStateVersion; };
          modules = [
            {
              system.stateVersion = systemStateVersion;
              nixpkgs.hostPlatform = "PLATFORM";
              users.users."${username}".home = "/Users/${username}";
            }
            donq.darwinModules."PLATFORM".default
            # ./custom-darwin-module.nix
            home-manager.darwinModules.home-manager
            {
              home-manager = {
                extraSpecialArgs = { inherit inputs outputs username hostname homeStateVersion systemStateVersion; };
                useGlobalPkgs = true;
                useUserPackages = true;
                users."${username}".imports = [
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
