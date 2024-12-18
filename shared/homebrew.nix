{
  homebrew = {
    enable = true;

    brews = [
      "mysql-client@9.0"
      "libpq"
    ];

    casks = [
      "dbeaver-community"
      "openvpn-connect"
      "mockoon"
      "raycast"
      "bruno"
    ];

    # use mdm to install apps
    # masApps = {
    #   "Numbers" = 409203825;
    #   "Pages" = 409201541;
    #   "Keynote" = 409183694;
    # };
  };
}
