{ lib, ... }:

{
  personal.nix = {
    enable = true;
    autoUpgrade = true;
    gc.enable = true;
    flake = "git+file:///etc/nixos/";
  };
  nix.settings.max-jobs = lib.mkDefault 1;
  system.autoUpgrade.flags = [ "--update-input" "personal-webpage/data" ];
}
