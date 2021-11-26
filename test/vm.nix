{ lib, ... }:
{
    imports = [ ../configuration.nix ];

    networking.domain = lib.mkForce "latitude7490";
}
