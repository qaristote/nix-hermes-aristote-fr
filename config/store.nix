{ ... }:

{
  nix = {
    autoOptimiseStore = true;
    experimental-features = [ "nix-command" "flakes" ];
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-old";
    };
    settings.max-jobs = lib.mkDefault 1;
  };
  system.autoUpgrade.enable = true;
}
