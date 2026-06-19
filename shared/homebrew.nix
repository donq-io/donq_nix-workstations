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
      "stripe-cli"
      "tmux"
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
      # `version :latest` cask: `brew upgrade` skips it unless greedy, so snix
      # would never pull a newer Claude Code without this.
      { name = "claude-code@latest"; greedy = true; }
      "codex"
      "codex-app"
      "google-chrome"
    ];
  };
}
