# Opinionated macOS UI defaults shared by DonQ workstations. Every value is
# mkDefault so consumers importing this module can override piecemeal.
{ lib, pkgs, ... }: {
  system.defaults.NSGlobalDomain = {
    InitialKeyRepeat = lib.mkDefault 15; # 25;
    KeyRepeat = lib.mkDefault 2; # 6;
    AppleScrollerPagingBehavior = lib.mkDefault true;
    AppleShowAllExtensions = lib.mkDefault true;
    AppleShowAllFiles = lib.mkDefault true;
    AppleShowScrollBars = lib.mkDefault "Always";
    NSAutomaticCapitalizationEnabled = lib.mkDefault false;
    NSAutomaticDashSubstitutionEnabled = lib.mkDefault false;
    NSAutomaticInlinePredictionEnabled = lib.mkDefault false;
    NSAutomaticQuoteSubstitutionEnabled = lib.mkDefault false;
    NSAutomaticSpellingCorrectionEnabled = lib.mkDefault false;
  };

  system.defaults.finder = {
    AppleShowAllExtensions = lib.mkDefault true;
    AppleShowAllFiles = lib.mkDefault true;
    CreateDesktop = lib.mkDefault false;
    FXPreferredViewStyle = lib.mkDefault "Nlsv";
    QuitMenuItem = lib.mkDefault true;
    ShowPathbar = lib.mkDefault true;
  };

  system.defaults.dock = {
    mineffect = lib.mkDefault null;
    autohide = lib.mkDefault true;
    autohide-delay = lib.mkDefault 0.1;
    autohide-time-modifier = lib.mkDefault 0.1;
    static-only = lib.mkDefault true;
    showhidden = lib.mkDefault true;
    tilesize = lib.mkDefault 60;
    show-recents = lib.mkDefault false;
  };

  system.startup.chime = lib.mkDefault false;

  fonts.packages = [
    pkgs.nerd-fonts.hack
  ];
}
