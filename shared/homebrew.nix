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
      "loom"
    ];

    caskArgs = {
      require_sha = false;
    };
  };
}
