{ ... }:

{
  nix = {
    autoOptimiseStore = true;
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-old";
    };
    settings.max-jobs = lib.mkDefault 1;
  };
  system.autoUpgrade.enable = true;
}
