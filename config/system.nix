{...}: {
  personal.system = {
    flake = "git+file:///etc/nixos/";
    autoUpgrade = {
      enable = true;
      remoteBuilding = {
        enable = true;
        builder.domain = "aristote.mesh";
      };
    };
  };
  system.autoUpgrade.allowReboot = true;
}
