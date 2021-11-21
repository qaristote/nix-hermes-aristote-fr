{ ... }:

{
  nix = {
    autoOptimiseStore = true;
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-old";
    };
  };
}
