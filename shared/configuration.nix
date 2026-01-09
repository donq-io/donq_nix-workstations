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
    snix = "nix flake lock --update-input donq ~/.config/nix && sudo darwin-rebuild switch --flake ~/.config/nix#default";
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
