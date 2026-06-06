# engram-nix

Nix flake packaging [Engram](https://github.com/Gentleman-Programming/engram) — persistent memory for AI coding agents — auto-updated daily via GitHub Actions.

## Try it

```bash
nix run github:yfloress/engram-nix -- --version
```

## Install (profile)

```bash
nix profile install github:yfloress/engram-nix
```

## Use as a flake input

```nix
{
  inputs.engram-nix.url = "github:yfloress/engram-nix";

  outputs = { self, nixpkgs, engram-nix }: {
    # add the package where you need it, e.g.:
    #   engram-nix.packages.${system}.default
  };
}
```

Pull new versions with your usual `nix flake update` + rebuild.

## How updates work

A scheduled GitHub Actions workflow runs `nix-update` daily, bumping the package
to the latest Engram release and committing the new version and hashes
automatically — no manual maintenance.

## License

MIT
