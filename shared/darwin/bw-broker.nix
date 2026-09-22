# bw-broker: approval-gated Bitwarden credentials for coding agents.
#
# The options themselves come from donq_bw-broker's own nix-darwin module; this
# wrapper only wires the org package (pkgs.donq.bw-broker, built against this
# flake's nixpkgs) and defaults the allowed callers to the machine's user.
# Importing it changes nothing: the daemon, its system user and its directories
# appear only once a machine sets
#
#   services.bw-broker.enable = true;
#
# after which the owner fills /etc/bw-broker/env (Telegram token and user id),
# logs the CLI in as the daemon user and runs `sudo bw-brokerctl unlock`.
# See https://github.com/donq-io/donq_bw-broker (README, "macOS con nix-darwin").
{ inputs }:
args@{ config, lib, pkgs, ... }: {
  imports = [ inputs.bw-broker.darwinModules.default ];

  config = {
    # 900 beats the upstream module's own mkDefault while still yielding to a
    # machine's plain assignment (as core.nix does for EDITOR).
    services.bw-broker.package = lib.mkOverride 900 pkgs.donq.bw-broker;

    # Generated fleet flakes pass `username` via specialArgs; hand-rolled
    # consumers fall back to system.primaryUser. A machine with neither must
    # list the callers itself (the upstream module asserts a non-empty list).
    services.bw-broker.allowedUsers = lib.mkDefault (
      if args ? username
      then [ args.username ]
      else lib.optional (config.system.primaryUser != null) config.system.primaryUser
    );
  };
}
