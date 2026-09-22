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

## Local environment variables

The shared `shell` Home Manager module loads `~/.config/nix/.env.local`
whenever Zsh starts, including non-interactive shells. The file is optional
and is read at runtime; its contents are not embedded in the Nix store.
Use shell statements with explicit exports:

```sh
export MY_API_TOKEN='your-value'
export MY_SERVICE_URL='https://example.com'
```

Create the file locally and restrict its permissions with
`chmod 600 ~/.config/nix/.env.local`. Both provisioning methods above add
`/.env.local` to the generated configuration's `.gitignore`. For existing
machine repositories, add that rule before creating the file. Keep this file
untracked and do not reference its contents from Nix expressions.

After updating `donq` and rebuilding once, changes to the file only require
a new Zsh shell, or `source ~/.config/nix/.env.local` in an existing one.
Variables are inherited by processes launched from that shell. Fish does not
source this shell-format file directly. The file path is fixed independently
of `donq.flakePath`.

If a machine already defines the same hook in a custom Home Manager module,
remove that local hook when adopting the shared one to avoid sourcing twice.
## Bitwarden credentials for coding agents

`darwinModules.default` carries [bw-broker](https://github.com/donq-io/donq_bw-broker)'s
options, inert until a machine opts in:

```nix
services.bw-broker.enable = true;
```

A coding agent then reaches one field of one vault item at a time with
`bw-agent run --item … --field … --env VAR --reason … -- <command>`, and the
owner approves each use on Telegram, seeing the command before it runs.
`darwin-rebuild switch` creates the `_bwbroker` system user, the `bw-agents`
group (this machine's user is added by default), the state and socket
directories, and the launchd daemon; it also puts `bw-agent`, `bw-brokerctl`
and `bw` on the system PATH. The Telegram token and user id go into
`/etc/bw-broker/env`, which the activation creates empty and readable only by
the daemon user — no secret ever reaches the Nix store. Setup, daily use and the
threat model are in the project's README.

## Keeping a machine in sync

When a system is operative, keep it in sync by periodically running the `snix`
alias (provided by `darwinModules.core`), which updates the `donq` lock input
and rebuilds:

```
nix flake update donq --flake ~/.config/nix
```

and then rebuilding and switching as usual. The flake location targeted by
`snix` is configurable via the `donq.flakePath` option.
