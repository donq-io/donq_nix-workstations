# nix-workstations

To initialize a system, you can either copy the verbatim flake template in the current folder

```bash
nix flake init -t 'github:donq-io/donq_nix-workstations'
```

or use the templating tool to generate a custom one in a specific path

```bash
nix run 'github:donq-io/donq_nix-workstations?ref=main#templater' myHostname myUsername myPlatform path/to/output/flake.nix
```

If a system is already configured, you can simply add the `donq` input to the existing flake and import its modules as the template above shows.

When a system is operative, it will be necessary to periodically update the `donq` input in the flake lock to keep all systems in sync; this can be achieved by running (in a cron, perhaps)

```
nix flake lock --update-input donq
```

and then rebuilding and switching as usual.
