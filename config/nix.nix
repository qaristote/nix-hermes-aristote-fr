{lib, ...}: {
  personal.nix = {
    enable = true;
    autoUpgrade = {
      enable = true;
      autoUpdateInputs = ["nixpkgs" "nixpkgs-unstable"];
    };
    gc.enable = true;
    flake = "git+file:///etc/nixos/";
  };
  nix.settings.max-jobs = lib.mkDefault 1;
  nixpkgs.flake = {
    setNixPath = true;
    setFlakeRegistry = true;
  };

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
