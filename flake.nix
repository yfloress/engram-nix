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
            version = "1.18.0";

            src = pkgs.fetchFromGitHub {
              owner = "Gentleman-Programming";
              repo = "engram";
              rev = "v${version}";
              hash = "sha256-kVoQG9hOjoOCUlz8yXIbHJrxoWI7NguU1npm++G8o/w=";
            };

            vendorHash = "sha256-O+pC4x4DKNUWr7Sx9iZOjK6a64wrQA4/lnjvkNLBX64=";

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
          default = engram;
        });
    };
}
