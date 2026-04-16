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
      "gh"
      "glow"
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
      "claude"
      "claude-code@latest"
      "codex"
      "codex-app"
      "google-chrome"
    ];
  };
}
