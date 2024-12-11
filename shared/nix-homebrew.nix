{ inputs, nix-homebrew, ... }: { username, ... }: {
  nix-homebrew = {
    enable = true;

    user = username;

    mutableTaps = false;
    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
      "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
    };
  };
}
