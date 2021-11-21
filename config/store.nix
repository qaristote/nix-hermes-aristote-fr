{ ... }:

{
  nix = {
    optimise.automatic = true;
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-old";
    };
  };
}
