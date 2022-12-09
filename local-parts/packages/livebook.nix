{lib, ...}: {
  perSystem = {
    config,
    pkgs,
    ...
  }: let
    beamPkgs = pkgs.beam.packages.erlangR25;
    # inherit (pkgs.callPackage ./lib.nix {inherit lib;}) buildEscript;
  in {
    packages = let
      inherit (beamPkgs) erlang rebar3;
      elixir = beamPkgs.elixir_1_14;
      hex = beamPkgs.hex.override {inherit elixir;};
      pname = "livebook";

      src = pkgs.fetchFromGitHub {
        owner = "livebook-dev";
        repo = "livebook";
        rev = "v${version}";
        sha256 = "sha256-0HsJGve4sLQ9cXpwwmMyo4R/wHaCwr22N32OX7O//oo=";
      };
      version = "0.8.0";
    in {
      livebook = beamPkgs.mixRelease {
        buildInputs = [];
        nativeBuildInputs = [pkgs.makeWrapper];

        mixFodDeps = beamPkgs.fetchMixDeps {
          inherit elixir src version;
          pname = "mix-deps-${pname}";
          sha256 = "sha256-tWJ4Rdv4TAY/6XI8cI7/GUfRXW34vrx2ZXlJYxDSGsU=";
        };
        inherit elixir hex pname src version;

        installPhase = ''
          mix escript.build

          mkdir -p $out/bin
          cp ./livebook $out/bin

          wrapProgram $out/bin/livebook \
            --prefix PATH : ${lib.makeBinPath [elixir erlang]} \
            --set MIX_REBAR3 ${rebar3}/bin/rebar3
        '';
      };
    };
  };
}