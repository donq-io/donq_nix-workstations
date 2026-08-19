{
  description = "DonQ's workstation configuration";

  inputs = {
    donq.url = "github:donq-io/donq_nix-workstations";
  };

  outputs = inputs @ { donq, ... }: {
    darwinConfigurations.default = donq.lib.mkWorkstation {
      inherit inputs;
      username = "USERNAME";
      platform = "PLATFORM";
      # Frozen at generation time; do not bump on existing machines.
      homeStateVersion = "25.05";
      systemStateVersion = 1;
      modules = [
        # ./custom-darwin-module.nix
      ];
      homeModules = [
        # ./custom-homemanager-module.nix
      ];
    };
  };
}
