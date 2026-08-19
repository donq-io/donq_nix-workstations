# Org interactive shell setup: zsh + fish + starship, and ssh client defaults.
{ ... }: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    # Freeform: keys are verbatim ssh_config directives.
    settings = {
      "*" = {
        SetEnv = {
          TERM = "xterm-256color"; # ghostty requires as it is not always recognized by remote server
        };
      };
    };
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    history.ignoreDups = true;
    historySubstringSearch.enable = true;
    shellAliases = {
      t = "timew";
    };
    initContent = ''
      # Usage: ssh-L [user@]host ports...
      ssh-L () { ssh -vN $(printf ' -L %1$s:localhost:%s' ''${@:2}) $1 }
    '';
  };

  programs.fish = {
    enable = true;
  };

  programs.starship = {
    enable = true;
    settings = {
      # username.show_always = true;j
      # hostname.ssh_only = false;
      memory_usage.disabled = false;
      status.disabled = false;
      sudo.disabled = false;
      docker_context.only_with_files = false;
    };
  };
}
