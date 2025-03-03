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
    ];

    caskArgs = {
      require_sha = false;
    };
  };
}
