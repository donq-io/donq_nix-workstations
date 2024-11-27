{ pkgs, pkgs-unstable, ... }: { ... }: {
  home.packages = [
    pkgs.darwin.xcode
    pkgs.nixpkgs-fmt
    pkgs.iterm2
    pkgs.age
    pkgs.just
    pkgs.go-task
    pkgs.terraform
    pkgs.terraform-ls
    pkgs.awscli2
    pkgs.minikube
    pkgs.kubectl
    pkgs.k9s
    pkgs.kustomize
    pkgs.ansible
    pkgs-unstable.devenv
    (pkgs-unstable.vscode-with-extensions.override {
      # When the extension is already available in the default extensions set.
      vscodeExtensions = with pkgs-unstable.vscode-extensions; [
        jnoortheen.nix-ide
        continue.continue
        esbenp.prettier-vscode
        mikestead.dotenv
        editorconfig.editorconfig
        mhutchie.git-graph
        oderwat.indent-rainbow
        bradlc.vscode-tailwindcss
        hashicorp.terraform
        bmewburn.vscode-intelephense-client
        eamodio.gitlens
      ]
      # When the extension is only available in the vscode-marketplace set.
      ++ pkgs-unstable.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "claude-dev";
          publisher = "saoudrizwan";
          version = "2.1.5";
          sha256 = "sha256-zNcGoVN+h/AEDwKKyISEobuWr0hQUf7xk7e+qsE1ly4=";
        }
      ];
    })
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

  home.file.".editorconfig".source = ./files/editor_config.ini;
  home.file.".justfile".source = ./files/justfile;
}
