{host, ...}: let
  inherit (import ../../hosts/${host}/variables.nix) panelChoice;
in {
  # Enable the noctalia-shell systemd service only when panelChoice == "noctalia"
  services.noctalia-shell.enable = panelChoice == "noctalia";
}
