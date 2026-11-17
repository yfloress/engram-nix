{
  description = "Nix flake packaging Engram, auto-updated daily via GitHub Actions";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = f:
        nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
    in
    {
      packages = forAllSystems (pkgs:
        let
          engram = pkgs.buildGoModule rec {
            pname = "engram";
            version = "3.7.2";

            src = pkgs.fetchFromGitHub {
              owner = "Gentleman-Programming";
              repo = "engram";
              rev = "v${version}";
              hash = "sha256-8vychLARVy7Ry+7hXx+NxnUR0KIUC5nJA+1XFduDB/M=";
            };

            vendorHash = "sha256-hkwwuqar4ngDUWM2XctkiVm8TpfQWnUws/sDxDyvQxU=";

            subPackages = [ "cmd/engram" ];

            env.CGO_ENABLED = 0;
            ldflags = [ "-s" "-w" "-X main.version=${version}" ];

            doCheck = false;

            meta = {
              description = "Persistent memory for AI coding agents via MCP";
              homepage = "https://github.com/Gentleman-Programming/engram";
              license = pkgs.lib.licenses.mit;
              mainProgram = "engram";
            };
          };
        in
        {
          inherit engram;
          # nix-update 1.16 assumes metadata copies sources to the store.
          # Nix >= 2.35 requires an explicit prefetch before getFlake.
          engram-updater = pkgs.nix-update.overrideAttrs (old: {
            patches = (old.patches or [ ]) ++ [ ./nix-update-prefetch.patch ];
          });
          default = engram;
        });
    };
}
