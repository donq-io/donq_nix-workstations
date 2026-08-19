---
type: reference
references:
  - ../flake.nix
  - ../template/flake.nix
  - ../README.md
---

# Workstation architecture

This is the evergreen reference for how DonQ macOS workstations are provisioned and kept in sync, and how the pieces of this repository fit together. It describes the design as it is; usage commands live in the [README](../README.md), and the history and rationale of how this design came to be live in the extended commit messages of the 2026-08 redesign series.

## Two consumption tiers

**Managed fleet.** MDM bootstraps a machine: it installs Determinate Nix, renders the template (`nix run …#templater`) into the machine flake at `~/.config/nix/flake.nix`, and runs the first `darwin-rebuild switch`. From then on MDM periodically runs `snix`, which relocks the `donq` input and rebuilds. The machine flake is data only — username, platform, frozen state versions, optional extra modules — and calls `lib.mkWorkstation` for everything else, so *all* wiring improvements ship centrally through the lock update.

**Mix and match.** A hand-rolled flake adds `donq` as an input and imports individual modules instead of calling `mkWorkstation`. This tier is a first-class consumer: every module must work without any of the others and without this repo's wiring.

## Flake outputs

- `darwinModules.{core, macos-defaults, homebrew}`, aggregated by `default`:
  - `core` — Determinate-managed Nix (`nix.enable = false`), primaryUser, shells, the `snix` alias (path configurable via the `donq.flakePath` option), and the `unstable` overlay. **Assumes Determinate**: never import it where nix-darwin manages the Nix daemon itself.
  - `macos-defaults` — UI opinions (dock, finder, keyboard), all overridable.
  - `homebrew` — nix-homebrew wiring (Homebrew itself is declaratively installed and pinned) plus the org brew/cask list.
- `homeManagerModules.{dev-tools, git, shell, dotfiles}`, aggregated by `default`. `dev-tools` expects `pkgs.unstable` (see overlay below).
- `overlays.unstable-packages` — exposes this flake's `nixpkgs-unstable` as `pkgs.unstable.*`. On x86_64-darwin it falls back to the stable set, because nixpkgs-unstable has dropped that platform (see constraints).
- `lib.mkWorkstation` — the full fleet-machine wiring: home-manager integration, specialArgs, platform/user setup. State versions are required arguments so they freeze per machine at generation time.
- `packages.templater` / `apps.templater` and `templates.default` — render the machine flake from `template/flake.nix`.
- Legacy aliases `darwinModules."<platform>".default` and `homeManagerModules."<platform>".default` keep machine flakes generated before the 2026-08 restructure working; they can be dropped once the fleet has been regenerated.

## Design principles

- **Org modules are polite guests.** Every opinionated option value is `lib.mkDefault` and every shipped package is `lib.lowPrio`, so a machine's own configuration always wins conflicts — silently, without `mkForce` or buildEnv collisions.
- **No specialArgs contract.** Modules never require bespoke specialArgs. `core` honors the `username` specialArg when a generated fleet flake provides it; hand-rolled consumers just set `system.primaryUser`.
- **One nixpkgs instantiation.** Modules take `pkgs` from module args and never import nixpkgs themselves; unstable arrives via the overlay. Consumer overlays therefore apply everywhere, including under home-manager's `useGlobalPkgs`.
- **State versions freeze at generation.** They record which release's behaviors a machine was initialized under and are never bumped on existing machines; the template's values only affect newly provisioned ones.
- **Everything ships via the lock.** Packages, module content, and (through `mkWorkstation`) wiring all propagate with `nix flake update donq` — no per-machine edits, ever.

## Constraints and lifecycles

- `darwinModules.core` is Determinate-only by design; with `nix.enable = false`, nix-darwin silently drops all `nix.*` settings, so Nix daemon configuration belongs in `/etc/nix/nix.custom.conf`.
- x86_64-darwin is end-of-line: nixpkgs 26.05 is its last release, with security fixes until the end of 2026. Until then Intel machines evaluate against stable everywhere (including `pkgs.unstable`, via the overlay fallback); afterwards the platform outputs and legacy aliases can be removed.
- Homebrew formulae/casks come from Homebrew's JSON API, not pinned git taps (Homebrew ≥ 4.6.4 rejects store-path taps); `snix` runs `brew update` first because the nix-homebrew wrapper pins `HOMEBREW_NO_AUTO_UPDATE=1`.
- There is deliberately no CI (decision, 2026-08): fleet breakage from the daily lock bumps surfaces only when a machine runs `snix`. Revisit if the fleet grows.
