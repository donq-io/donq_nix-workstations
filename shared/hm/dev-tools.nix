# DonQ development toolchain. Expects an `unstable` overlay on pkgs
# (donq's overlays.unstable-packages, applied by darwinModules.core, or a
# compatible one).
{ pkgs, ... }: {
  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/go/bin"
  ];

  home.sessionVariables = {
    NIX_CONFIG = "experimental-features = nix-command flakes";
    NIX_PATH = "nixpkgs=flake:nixpkgs";
  };

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
    pkgs.neovim

    pkgs.nodejs_22
    pkgs.bun

    pkgs.unstable.python314
    pkgs.unstable.python314Packages.pip
    pkgs.unstable.python314Packages.uv
    pkgs.unstable.iterm2
    pkgs.unstable.devenv
    pkgs.unstable.ngrok
    pkgs.unstable.vscode
  ];

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
}
