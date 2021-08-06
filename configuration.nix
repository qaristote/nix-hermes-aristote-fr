{ ... }:

{
  imports = [ ./config ./modules ];

  nixpkgs = {
    overlays =
      [ (final: prev: { personal = import ./pkgs { pkgs = final; }; }) ];
  };
}
