{ pkgs, lib, ... }:

{
  personal.nix = {
    enable = true;
    autoUpgrade = true;
    gc.enable = true;
    flake = "git+file:///etc/nixos/";
  };
  nix.settings.max-jobs = lib.mkDefault 1;

  system.autoUpgrade.flags =
    pkgs.personal.lib.updateInputFlag "nixpkgs-unstable";

  systemd.services.nixos-upgrade = {
    # restart at most once every hour
    serviceConfig = {
      Restart = "on-failure";
      RestartSec = "5sec";
    };
    startLimitBurst = 1;
    startLimitIntervalSec = 3600;
  };
}
