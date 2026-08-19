# nix-workstations

DonQ's shared Nix modules for macOS workstations. Machines consume this repo
as the `donq` flake input; all the wiring lives here (see `lib.mkWorkstation`),
so fleet machines pick up improvements with a simple lock update.

This file covers usage. For how the pieces fit together — the two consumption
tiers, the flake outputs, and the design principles — see
[docs/architecture.md](docs/architecture.md).

## Provisioning a machine

To initialize a system, you can either copy the verbatim flake template in the current folder

```bash
nix flake init -t 'github:donq-io/donq_nix-workstations'
```

or use the templating tool to generate a custom one in a specific path

```bash
nix run 'github:donq-io/donq_nix-workstations?ref=main#templater' myUsername myPlatform path/to/output/flake.nix
```

## Mixing into an existing configuration

If a system already has a hand-rolled flake, add the `donq` input and import
the granular modules you want instead of using `mkWorkstation`:

- `darwinModules`: `core`, `macos-defaults`, `homebrew` (or `default` for all).
  Careful with `core`: it assumes Nix is managed by the Determinate installer
  (`nix.enable = false`) — don't import it where nix-darwin manages the daemon.
- `homeManagerModules`: `dev-tools`, `git`, `shell`, `dotfiles` (or `default`).
  `dev-tools` expects an `unstable` overlay on `pkgs` (use
  `overlays.unstable-packages`, which `darwinModules.core` applies).

For example, to sync the org toolchain into your own home-manager setup while
keeping everything else personal:

```nix
inputs.donq.url = "github:donq-io/donq_nix-workstations";
# ... in your home-manager user imports:
donq.homeManagerModules.dev-tools
```

Org modules are polite guests: option values are `mkDefault` and packages are
`lowPrio`, so the machine's own configuration always wins conflicts.

## Keeping a machine in sync

When a system is operative, keep it in sync by periodically running the `snix`
alias (provided by `darwinModules.core`), which updates the `donq` lock input
and rebuilds:

```
nix flake update donq --flake ~/.config/nix
```

and then rebuilding and switching as usual. The flake location targeted by
`snix` is configurable via the `donq.flakePath` option.
