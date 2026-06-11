{ pkgs, pkgs-unstable, ... }:
{ inputs, username, ... }: {
  # Auto upgrade nix package and the daemon service.
  # nix.package = pkgs.nix;

  nix.enable = false;

  system.primaryUser = username;

  services.openssh.enable = true;

  nix.settings.experimental-features = "nix-command flakes";

  nix.settings.trusted-users = [ "root" username ];

  nixpkgs.config.allowUnfree = true;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  programs.fish.enable = true;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  system.defaults.NSGlobalDomain = {
    InitialKeyRepeat = 15; # 25;
    KeyRepeat = 2; # 6;
    AppleScrollerPagingBehavior = true;
    AppleShowAllExtensions = true;
    AppleShowAllFiles = true;
    AppleShowScrollBars = "Always";
    NSAutomaticCapitalizationEnabled = false;
    NSAutomaticDashSubstitutionEnabled = false;
    NSAutomaticInlinePredictionEnabled = false;
    NSAutomaticQuoteSubstitutionEnabled = false;
    NSAutomaticSpellingCorrectionEnabled = false;
  };

  system.defaults.finder = {
    AppleShowAllExtensions = true;
    AppleShowAllFiles = true;
    CreateDesktop = false;
    FXPreferredViewStyle = "Nlsv";
    QuitMenuItem = true;
    ShowPathbar = true;
  };

  system.defaults.dock = {
    mineffect = null;
    autohide = true;
    autohide-delay = 0.1;
    autohide-time-modifier = 0.1;
    static-only = true;
    showhidden = true;
    tilesize = 60;
    show-recents = false;
  };

  system.startup.chime = false;

  environment.shellAliases = {
    # `brew update` refreshes Homebrew's JSON API catalog before the rebuild's
    # `brew bundle` runs. The nix-homebrew brew wrapper hardcodes
    # HOMEBREW_NO_AUTO_UPDATE=1, so brew never refreshes the catalog on its own;
    # since we install formulae/casks from the API (not pinned git taps), without
    # this explicit update brew never sees new versions and upgrade is a no-op.
    # It runs as the user so it warms the same ~/Library/Caches/Homebrew/api that
    # the activation's `brew bundle` (run as this user) then reads.
    snix = "nix flake update donq --flake ~/.config/nix && brew update && sudo darwin-rebuild switch --flake ~/.config/nix#default";
  };

  fonts.packages = [
    pkgs.nerd-fonts.hack
  ];

  environment.variables = {
    EDITOR = "vim";
  };

  nix.extraOptions = ''
    extra-nix-path = nixpkgs=flake:nixpkgs
  '';

  environment.systemPackages = [
  ];
}
