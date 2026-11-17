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

A scheduled GitHub Actions workflow refreshes nixpkgs and runs
`nix run .#engram-updater` daily. The updater uses the nixpkgs revision in
`flake.lock`, selects stable `vX.Y.Z` releases, and builds Engram before
committing the new version and hashes.

The updater carries `nix-update-prefetch.patch` because nix-update 1.16 assumes
`nix flake metadata` copies sources into the store. Nix 2.35 defers that copy;
the patch explicitly prefetches the exact source on every evaluation, including
after edits. Remove the patch once the locked nix-update includes this fix.

## License

MIT
