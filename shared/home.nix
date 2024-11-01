{ pkgs, ... }: {
  home.packages = with pkgs; [
    nixpkgs-fmt
    iterm2
    age
    just
    go-task
    direnv
    terraform
    terraform-ls
    awscli2
    minikube
    kubectl
    k9s
    kustomize
    ansible
  ];

  programs = {
    ssh = {
      enable = true;

      matchBlocks = {
        "10.222.222.*" = {
          user = "root";
          proxyJump = "pve-bastion";
        };

        "nix-starter" = {
          hostname = "10.222.222.199";
          user = "root";
          proxyJump = "pve-bastion";
        };

        "pve-bastion" = {
          hostname = "admin100.donq.org";
          port = 49152;
          user = "root";
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
}
