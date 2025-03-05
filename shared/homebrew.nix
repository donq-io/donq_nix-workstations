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
      # "raycast" temporary disabled due wrong version on brew
      "loom"
      "docker"
    ];

    caskArgs = {
      require_sha = false;
    };
  };
}
