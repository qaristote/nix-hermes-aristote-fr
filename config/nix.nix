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

  systemd.services.nixos-upgrade = let
    mkForce = lib.mkOverride 51;
  in {
    # restart at most once every hour
    serviceConfig = {
      Restart = "on-failure";
      RestartSec = "5sec";
      MemoryAccounting = true;
      MemoryHigh = "1G";
      MemoryMax = "1.5G";
    };
    startLimitBurst = mkForce 1;
    startLimitIntervalSec = mkForce 3600;
  };
}
