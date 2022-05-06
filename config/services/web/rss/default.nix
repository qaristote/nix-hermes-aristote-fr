{ config, lib, pkgs, ... }:

let
  cfg = config.services.rss-bridge;
  debug = false;
  rss-bridge = pkgs.rss-bridge.overrideAttrs (oldAttrs:
    oldAttrs // {
      installPhase = oldAttrs.installPhase + ''
        ln -sf ${./ParisJazzClubBridge.php} $out/bridges/ParisJazzClubBridge.php
      '' + lib.optionalString debug ''
        touch $out/DEBUG
      '';
    });
in {
  services.rss-bridge = {
    enable = true;
    whitelist = [ "ParisJazzClub" ];
    virtualHost = "rss";
  };

  services.nginx = lib.mkIf (cfg.virtualHost != null) {
    virtualHosts.${cfg.virtualHost} = {
      serverName = "rss.${config.networking.domain}";
      root = lib.mkForce "${rss-bridge}";
      forceSSL = true;
      enableACME = true;
    };
  };
}
