{...}: {
  personal.nix = {
    enable = true;
    autoUpgrade = {
      enable = true;
      autoUpdateInputs = ["nixpkgs" "nixpkgs-unstable"];
    };
    gc.enable = true;
    flake = "git+file:///etc/nixos/";
    remoteBuilds = {
      enable = true;
      machines.hephaistos = {
        enable = true;
        domain = "aristote.mesh";
      };
    };
  };

  nix.settings.max-jobs = 1;
  nixpkgs.flake = {
    setNixPath = true;
    setFlakeRegistry = true;
  };

  systemd.services.nixos-upgrade.serviceConfig = {
    MemoryAccounting = true;
    MemoryHigh = "1G";
    MemoryMax = "1.5G";
  };
}
