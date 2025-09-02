{ pkgs, pkgs-unstable, ... }: { ... }: {
  home.packages = [
    pkgs.nixpkgs-fmt
    pkgs.age
    pkgs.just
    pkgs.go-task
    pkgs.terraform
    pkgs.terraform-ls
    pkgs.awscli2
    pkgs.ssm-session-manager-plugin
    pkgs.minikube
    pkgs.kubectl
    pkgs.k9s
    pkgs.kustomize
    pkgs.ansible
    pkgs.ffmpeg
    pkgs.openvpn

    pkgs.nodejs_22

    pkgs-unstable.iterm2
    pkgs-unstable.devenv
    pkgs-unstable.ngrok
    pkgs-unstable.arc-browser
    pkgs-unstable.vscode
  ];

  programs = {
    ssh = {
      enable = true;

      matchBlocks = {
        "*" = {
          setEnv = {
            TERM = "xterm-256color";
          };
        };
      };
    };

    lazygit = {
      enable = true;
    };

    git = {
      enable = true;
      lfs.enable = true;
      delta.enable = true;
      delta.options = {
        line-numbers = true;
        side-by-side = true;
        navigate = true;
      };
      extraConfig = {
        user.useConfigOnly = true;
        # Automatically handle !fixup and !squash commits -- see https://thoughtbot.com/blog/autosquashing-git-commits
        rebase.autosquash = "true";
        # Improve merge conflicts style showing base -- see https://ductile.systems/zdiff3/
        merge.conflictstyle = "zdiff3";
        # Different color for moves in diffs.
        diff.colorMoved = "default";
        # Default branch name.
        init.defaultBranch = "main";
        # Help with autocorrect but ask for permission.
        help.autocorrect = "prompt";
        # Use ISO dates.
        log.date = "iso";
        # Probably easier diffs when permuting functions.
        diff.algorithm = "histogram";
        # Sort branches by last commit.
        branch.sort = "-committerdate";
      };
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      history.ignoreDups = true;
      historySubstringSearch.enable = true;
      shellAliases = {
        t = "timew";
      };
      initExtra = ''
        # Usage: ssh-L [user@]host ports...
        ssh-L () { ssh -vN $(printf ' -L %1$s:localhost:%s' ''${@:2}) $1 }
      '';
    };

    fish = {
      enable = true;
    };

    starship = {
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
  };

  home.file.".editorconfig".source = ./files/editor_config.ini;
  home.file.".justfile".source = ./files/justfile;
}
