{
  description = "My Elixir application";

  inputs = {
    beam-flakes.url = "path:./../..";
    beam-flakes.inputs.flake-parts.follows = "flake-parts";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = inputs @ {
    beam-flakes,
    flake-parts,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [beam-flakes.flakeModule];

      systems = ["aarch64-darwin" "x86_64-darwin" "x86_64-linux"];

      perSystem = _: {
        beamWorkspace = {
          enable = true;
          devShell.languageServers.elixir = true;
          devShell.languageServers.erlang = false;
          flakePackages = true;
          versions = {
            elixir = "1.15.6-otp-26";
            erlang = "26.1.2";
          };
          # versions.fromToolVersions = ./.tool-versions;
        };
      };
    };
}
