{ pkgs, ... }: {
  home.stateVersion = "24.05";
  home.username = "mrbash";
  # home.homeDirectory = "/Users/mrbash";
  # programs.home-manager.enable = true;
  # programs.ssh.enable = true;
  home.packages = with pkgs; [
    # NOTE: we use colima instead of Docker Desktop as a runtime
    # Ref: https://www.tyler-wright.com/blog/using-colima-on-an-m1-m2-mac/
    # First startup:
    # * `softwareupdate --install-rosetta --agree-to-license`
    # * `colima start --arch aarch64 --vm-type=vz --vz-rosetta`
    iterm2
    age
    colima
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

  programs.ssh = {
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

    includes = [
      "~/.ssh/config_pve" # NOTE: colima isn't being particularly smart about it.
    ];
  };
}
