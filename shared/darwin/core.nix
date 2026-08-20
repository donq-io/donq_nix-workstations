# Baseline system plumbing shared by every DonQ workstation.
args@{ config, lib, ... }: {
  options.donq.flakePath = lib.mkOption {
    type = lib.types.str;
    default = "~/.config/nix";
    description = "Location of the machine flake targeted by the `snix` alias.";
  };

  config = {
    # Nix itself is managed by the Determinate installer, not nix-darwin. With
    # nix.enable = false, nix-darwin drops ALL nix.* settings (nix.settings,
    # nix.extraOptions, ...) via `mkIf cfg.enable` in its modules/nix/default.nix,
    # so setting them here is a silent no-op — configure /etc/nix/nix.custom.conf
    # instead.
    nix.enable = false;

    # Generated fleet flakes provide `username` via specialArgs; hand-rolled
    # consumers set system.primaryUser themselves and never pass the arg.
    system.primaryUser = lib.mkIf (args ? username) (lib.mkDefault args.username);

    services.openssh.enable = lib.mkDefault true;

    nixpkgs.config.allowUnfree = lib.mkDefault true;

    # Create /etc/zshrc that loads the nix-darwin environment.
    programs.zsh.enable = lib.mkDefault true; # default shell on catalina
    programs.fish.enable = lib.mkDefault true;

    # Set Git commit hash for darwin-version (the machine flake's revision).
    system.configurationRevision = lib.mkIf (args ? inputs)
      (lib.mkDefault (args.inputs.self.rev or args.inputs.self.dirtyRev or null));

    # `brew update` refreshes Homebrew's JSON API catalog before the rebuild's
    # `brew bundle` runs. The nix-homebrew brew wrapper hardcodes
    # HOMEBREW_NO_AUTO_UPDATE=1, so brew never refreshes the catalog on its own;
    # since we install formulae/casks from the API (not pinned git taps), without
    # this explicit update brew never sees new versions and upgrade is a no-op.
    # It runs as the user so it warms the same ~/Library/Caches/Homebrew/api that
    # the activation's `brew bundle` (run as this user) then reads.
    environment.shellAliases.snix =
      "nix flake update donq --flake ${config.donq.flakePath} && brew update && sudo darwin-rebuild switch --flake ${config.donq.flakePath}#default";

    # nix-darwin itself mkDefaults EDITOR to "nano", so plain mkDefault would
    # conflict; 900 beats that while still yielding to a consumer's plain
    # assignment.
    environment.variables.EDITOR = lib.mkOverride 900 "vim";
  };
}
