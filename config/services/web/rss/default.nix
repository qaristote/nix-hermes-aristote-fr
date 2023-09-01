{ config, lib, pkgs, ... }:

let cfg = config.services.rss-bridge;
in {
  services.rss-bridge = {
    enable = true;
    extraBridges = [
      # Music
      {
        name = "FipAlbums";
        source = ./FipAlbumsBridge.php;
      }
      ## Concerts
      {
        name = "ParisJazzClub";
        source = ./ParisJazzClubBridge.php;
      }
      {
        name = "MaisonDeLaRadio";
        source = ./MaisonDeLaRadioBridge.php;
      }
      # Cinema
      {
        name = "WhatsOnMubi";
        source = ./WhatsOnMubiBridge.php;
      }
      {
        name = "ParisCineInfo";
        source = ./ParisCineInfoBridge.php;
      }
    ];
    virtualHost = "rss";
  };

  services.nginx = lib.mkIf (cfg.virtualHost != null) {
    virtualHosts.${cfg.virtualHost} = {
      serverName = "rss.${config.networking.domain}";
      forceSSL = true;
      enableACME = true;
    };
  };

  systemd.services.phpfpm-rss-bridge.personal.monitor = true;
}
