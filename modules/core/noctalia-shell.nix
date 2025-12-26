{config, ...}: let
  inherit (config.zaneyos) barChoice;
in {
  # Enable the noctalia-shell systemd service only when barChoice == "noctalia"
  services.noctalia-shell.enable = barChoice == "noctalia";
}
