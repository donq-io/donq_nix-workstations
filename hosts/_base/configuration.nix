{ pkgs, inputs, user, hostname, ... }: {
  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  nixpkgs.config.allowUnfree = true;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  programs.fish.enable = true;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  security.pam.enableSudoTouchIdAuth = true;

  networking.hostName = hostname;
  networking.localHostName = hostname;

  users.users."${user}" = {
    home = "/Users/${user}";
    shell = pkgs.fish;
  };

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
    snix = "darwin-rebuild switch --flake ~/Workspace/nix/flake.nix#dq-matterhorn";
  };

  fonts.packages = with pkgs; [ (nerdfonts.override { fonts = [ "Hack" ]; }) ];

  environment.variables = {
    EDITOR = "vim";
  };

  # NOTE: this is the default in the DeterminateSystems conf and repairs nix-shell
  nix.extraOptions = ''
    extra-nix-path = nixpkgs=flake:nixpkgs
  '';

  nix.linux-builder.enable = true;

  launchd = {
    user = {
      agents = {
        iterm2-start = {
          command = "${pkgs.iterm2}/Contents/MacOS/iTerm2";
          serviceConfig = {
            KeepAlive = true;
            RunAtLoad = true;
          };
        };
      };
    };
  };
}