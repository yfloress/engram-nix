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
            version = "3.5.1";

            src = pkgs.fetchFromGitHub {
              owner = "Gentleman-Programming";
              repo = "engram";
              rev = "v${version}";
              hash = "sha256-CaazkHlpCkbmPlntgHoW88j3WnoMSvgaKWSQKZCArd8=";
            };

            vendorHash = "sha256-LH8sSmer918+KL5hnOju7b5NsZo+W9sd3HhkQgjS2Ho=";

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
