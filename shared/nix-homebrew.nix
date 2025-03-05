{ inputs, ... }: { username, ... }: {
  nix-homebrew = {
    enable = true;
    user = username;
    mutableTaps = false;
    autoMigrate = true;
    enableRosetta = true;

    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
      "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
    };
  };
}
