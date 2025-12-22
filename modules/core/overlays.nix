{inputs, ...}: {
  nixpkgs.overlays = [
    # Provide pkgs.google-antigravity via antigravity-nix overlay
    inputs.antigravity-nix.overlays.default

    # Local packages overlay
    (final: prev: {
      # Helium browser (AppImage wrapped)
      helium = prev.callPackage ../../pkgs/helium { };
    })
  ];
}
