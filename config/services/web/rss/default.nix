{
  config,
  lib,
  ...
}: let
  cfg = config.services.rss-bridge;
in {
  services.rss-bridge = {
    enable = true;
    extraBridges = [
      {
        name = "Randonavigo";
        source = ./RandonavigoBridge.php;
      }
      # Music
      {
        name = "FipAlbums";
        source = ./FipAlbumsBridge.php;
      }
      ## Concerts
      {
        name = "MaisonDeLaRadio";
        source = ./MaisonDeLaRadioBridge.php;
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
