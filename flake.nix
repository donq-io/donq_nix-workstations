{
  description = "DonQ's shared Nix modules";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";

    # Pin the Homebrew frontend itself. Formulae/casks come from the JSON API
    # (formulae.brew.sh), so we no longer pin homebrew-core/homebrew-cask.
    brew-src = {
      url = "github:Homebrew/brew";
      flake = false;
    };

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    nix-homebrew.inputs.brew-src.follows = "brew-src";
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
  };

  outputs =
    inputs @ { self
    , flake-utils
    , nixpkgs
    , nixpkgs-unstable
    , nix-homebrew
    , ...
    }:
    let
      overlays = {
        # Exposes this flake's nixpkgs-unstable as `pkgs.unstable`. On
        # x86_64-darwin — dropped by nixpkgs-unstable, with 26.05 the last
        # stable release (security fixes until end of 2026) — `unstable` falls
        # back to the stable set so Intel machines keep evaluating until EOL.
        unstable-packages = _final: prev: {
          unstable =
            # `prev`, not `final`: later overlays alias into `unstable`
            # (e.g. ruby_4_0 below), and a `final` fallback would self-loop.
            if prev.stdenv.hostPlatform.isDarwin && prev.stdenv.hostPlatform.isx86_64
            then prev
            else import nixpkgs-unstable {
              system = prev.stdenv.hostPlatform.system;
              config.allowUnfree = true;
            };
        };
      };

      # All modules are system-agnostic: they take `pkgs` from module args and
      # never instantiate nixpkgs themselves. Consumers pick the pieces they
      # want; `default` aggregates everything for fleet machines.
      darwinModules = rec {
        # Baseline plumbing: Determinate nix, primaryUser, shells, snix alias.
        # NOTE: assumes Nix is managed by the Determinate installer
        # (nix.enable = false) — don't import this on a machine where
        # nix-darwin manages the nix daemon/settings itself.
        core = { ... }: {
          imports = [ ./shared/darwin/core.nix ];
          nixpkgs.overlays = [
            overlays.unstable-packages
            (final: _prev: { ruby_4_0 = final.unstable.ruby_4_0; })
          ];
        };
        # Opinionated macOS UI defaults (all mkDefault: override freely).
        macos-defaults = ./shared/darwin/macos-defaults.nix;
        # Declarative Homebrew: nix-homebrew wiring plus the org package list.
        homebrew = { ... }: {
          imports = [
            nix-homebrew.darwinModules.nix-homebrew
            (import ./shared/darwin/nix-homebrew.nix { inherit inputs; })
            ./shared/darwin/homebrew.nix
          ];
        };
        default = { ... }: { imports = [ core macos-defaults homebrew ]; };
        # Legacy aliases: generated machine flakes reference
        # darwinModules."<platform>".default.
        aarch64-darwin.default = default;
        x86_64-darwin.default = default;
      };

      homeManagerModules = rec {
        # Org development toolchain; needs an `unstable` overlay on pkgs
        # (darwinModules.core provides one).
        dev-tools = ./shared/hm/dev-tools.nix;
        git = ./shared/hm/git.nix;
        shell = ./shared/hm/shell.nix;
        dotfiles = ./shared/hm/dotfiles.nix;
        default = { ... }: { imports = [ dev-tools git shell dotfiles ]; };
        # Legacy aliases, as above.
        aarch64-darwin.default = default;
        x86_64-darwin.default = default;
      };

      # All the wiring a fleet machine needs, kept central so improvements ship
      # via `nix flake update donq` instead of being frozen into generated
      # flakes. The machine flake only provides data (see template/flake.nix).
      # State versions are required on purpose: they must be frozen per machine
      # at generation time, never drift with a donq update.
      mkWorkstation =
        { username
        , platform
        , homeStateVersion
        , systemStateVersion
        , inputs ? { }   # the machine flake's inputs (for configurationRevision etc.)
        , modules ? [ ]  # extra darwin modules
        , homeModules ? [ ]  # extra home-manager modules
        , specialArgs ? { }
        }:
        let
          allSpecialArgs = {
            inherit inputs username platform homeStateVersion systemStateVersion;
          } // specialArgs;
        in
        self.inputs.nix-darwin.lib.darwinSystem {
          specialArgs = allSpecialArgs;
          modules = [
            {
              system.stateVersion = systemStateVersion;
              nixpkgs.hostPlatform = platform;
              users.users.${username}.home = "/Users/${username}";
            }
            darwinModules.default
            self.inputs.home-manager.darwinModules.home-manager
            {
              home-manager = {
                extraSpecialArgs = allSpecialArgs;
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "nix.old";
                users.${username}.imports = [
                  { home.stateVersion = homeStateVersion; }
                  homeManagerModules.default
                ] ++ homeModules;
              };
            }
          ] ++ modules;
        };
    in
    flake-utils.lib.eachSystem [ "aarch64-darwin" "x86_64-darwin" ]
      (
        system:
        let
          pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
        in
        {
          packages.templater = pkgs.writeShellApplication {
            name = "templater";
            runtimeInputs = [ pkgs.gnused ];
            text = ''
              flake_directory=$(dirname "$3")
              mkdir -p "$flake_directory"
              sed -e "s/USERNAME/$1/g" -e "s/PLATFORM/$2/g" ${self}/template/flake.nix > "$3"
            '';
          };

          # USAGE: nix run .#templater -- username platform path/to/output/flake.nix
          apps.templater = {
            type = "app";
            program = "${self.packages.${system}.templater}/bin/templater";
          };
        }
      )
    // {
      inherit overlays darwinModules homeManagerModules;

      lib = { inherit mkWorkstation; };

      templates.default = {
        path = ./template;
        description = "DonQ's workstation configuration template";
      };
    };
}
