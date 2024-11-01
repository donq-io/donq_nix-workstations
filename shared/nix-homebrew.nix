{ inputs, nix-homebrew, user, ... }: {
  nix-homebrew = {
    enable = true;

    user = user;

    mutableTaps = false;
    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
      "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
    };
  };
}
