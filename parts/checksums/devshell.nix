{self, ...}: {
  perSystem = {
    config,
    pkgs,
    self',
    ...
  }: {
    devShells.update = pkgs.mkShell {
      buildInputs = with config.packages; [
        add-elixir-version
        add-otp-version
        nix-prefetch-elixir
        nix-prefetch-otp
      ];
    };
  };
}
