{
  homebrew = {
    enable = true;

    brews = [
      "mysql-client"
      "libpq"
      "watchman"
    ];

    casks = [
      "dbeaver-community"
      "openvpn-connect"
      "mockoon"
      "bruno"
      "raycast"
    ];

    # use mdm to install apps
    # masApps = {
    #   "Numbers" = 409203825;
    #   "Pages" = 409201541;
    #   "Keynote" = 409183694;
    # };
  };
}
