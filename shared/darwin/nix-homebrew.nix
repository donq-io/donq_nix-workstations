# nix-homebrew wiring: installs and pins the Homebrew frontend itself.
# `inputs` here are donq's own flake inputs (the brew pins), closed over in
# flake.nix — not the consumer's.
{ inputs }: { config, ... }: {
  nix-homebrew = {
    enable = true;
    user = config.system.primaryUser;
    mutableTaps = false;
    autoMigrate = true;
    #enableRosetta = true;

    # Formulae and casks are installed from Homebrew's JSON API
    # (formulae.brew.sh), the default since Homebrew 4.0. We no longer pin
    # homebrew-core/homebrew-cask as git taps: Homebrew 4.6.4+ rejects loading
    # formulae from a path outside Library/Taps, and nix-homebrew's tap symlinks
    # resolve into /nix/store, tripping that check during `brew bundle`.
    # Only homebrew-bundle is a real command, so it stays tapped.
    taps = {
      "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
    };
  };
}
