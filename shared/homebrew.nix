{
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      #cleanup = "uninstall";
      upgrade = true;
    };

    brews = [
      "mysql-client"
      "libpq"
      "watchman"
      "gemini-cli"
      "opencode"
    ];

    casks = [
      "dbeaver-community"
      "openvpn-connect"
      "yaak"
      "raycast"
      "loom"
      "docker-desktop"
      "cloudflare-warp"
      "sublime-text"
      "switchhosts"
      "redis-insight"
      "arc"
      "chatgpt"
      "claude-code"
      "codex"
      "google-chrome"
    ];
  };
}
