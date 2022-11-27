{ config, lib, pkgs, ... }:

let
  cfg = config.services.rss-bridge;
  # debug = true;
  # rss-bridge = pkgs.rss-bridge.overrideAttrs (oldAttrs:
  #   oldAttrs // {
  #     installPhase = oldAttrs.installPhase + ''
  #       pushd $out/bridges
  #       ln -sf ${./ParisJazzClubBridge.php} ParisJazzClubBridge.php
  #       ln -sf ${./MaisonDeLaRadioBridge.php} MaisonDeLaRadioBridge.php
  #       ln -sf ${./FipAlbumsBridge.php} FipAlbumsBridge.php
  #       ln -sf ${./WhatsOnMubiBridge.php} WhatsOnMubiBridge.php
  #       popd
  #     '' + lib.optionalString debug ''
  #       touch $out/DEBUG
  #     '';
  #   });
in {
  services.rss-bridge = {
    enable = true;
    # whitelist = [ "ParisJazzClub" "MaisonDeLaRadio" "FipAlbumsBridge" "WhatsOnMubi" ];
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
    ];
    virtualHost = "rss";
  };

  services.nginx = lib.mkIf (cfg.virtualHost != null) {
    virtualHosts.${cfg.virtualHost} = {
      serverName = "rss.${config.networking.domain}";
      # root = lib.mkForce "${rss-bridge}";
      forceSSL = true;
      enableACME = true;
    };
  };
}
