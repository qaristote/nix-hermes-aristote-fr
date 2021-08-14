{ config, lib, ... }:

let
  cfg = {
    searx = config.services.searx;
    filtron = config.services.filtron;
  };
in {
  imports = [ ./searx ./filtron ./morty ];

  services.nginx.virtualHosts."searx.aristote.fr" =
    lib.mkIf (cfg.searx.enable && cfg.filtron.enable) {
      locations = {
        "/" = {
          proxyPass = "http://${cfg.filtron.listen.address}:${
              toString cfg.filtron.listen.port
            }";
          extraConfig = ''
            proxy_set_header Host            $host;
            proxy_set_header Connection      $http_connection;
            proxy_set_header X-Real-IP       $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Scheme        $scheme;
            # proxy_set_header X-Script-Name   /;
          '';
        };
        "/static".alias = "${pkgs.searx}/sjare/static";
      };
      forceSSL = true;
      enableACME = true;
    };
}
