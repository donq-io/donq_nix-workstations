{
  homebrew = {
    enable = true;

    brews = [
      "mysql-client@9.0"
      "libpq"
    ];

    casks = [
      # "google-chrome"
      # "firefox"
      "dbeaver-community"
      "openvpn-connect"
    ];

    masApps = {
      "Numbers" = 409203825;
      "Pages" = 409201541;
      "Keynote" = 409183694;
    };
  };
}
