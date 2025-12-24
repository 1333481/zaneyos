{
  config,
  lib,
  pkgs,
  username,
  ...
}:
lib.mkIf config.zaneyos.scannerEnable {
  hardware.sane = {
    enable = true;
    extraBackends = [pkgs.sane-airscan];
    disabledDefaultBackends = ["escl"];
  };

  users.users.${username}.extraGroups = ["scanner"];
}
