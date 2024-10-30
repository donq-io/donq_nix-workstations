{
  description = "DonQ's workstation configuration template";

  inputs = {
    # donq.url = "github:donq-io/donq_nix-workstations";
    donq.url = "path:/Users/Brasolin/dq/donq_nix-workstations";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    donq,
    nixpkgs,
    nix-darwin,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
  in {
    darwinConfigurations = {
      "HOST_NAME" = nix-darwin.lib.darwinSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          {nixpkgs.hostPlatform = "aarch64-darwin";}
          donq.darwinModules.default
          # ./custom-darwin-module.nix
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              extraSpecialArgs = {inherit inputs outputs;};
              useGlobalPkgs = true;
              useUserPackages = true;
              users."USER_NAME".imports = [
                donq.homeManagerModules.default
                # ./custom-homemanager-module.nix
              ];
            };
          }
        ];
      };
    };
  };
}
