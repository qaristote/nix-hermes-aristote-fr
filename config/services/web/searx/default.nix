{
  config,
  lib,
  ...
}:

let
  cfg = {
    searx = config.services.searx;
    filtron = config.services.filtron;
  };
in
{
  imports = [
    ./searx
    ./filtron
  ];

  services.nginx.virtualHosts.searx = lib.mkIf (cfg.searx.enable && cfg.filtron.enable) {
    serverName = "searx.${config.networking.domain}";
    locations = {
      "/" = {
        proxyPass = "http://${cfg.filtron.listen.address}:${toString cfg.filtron.listen.port}";
        extraConfig = ''
          proxy_set_header Connection      $http_connection;
          proxy_set_header X-Scheme        $scheme;
          # proxy_set_header X-Script-Name   /;
        '';
      };
      "/static/".alias = "${cfg.searx.package}/share/static/";
    };
    forceSSL = true;
    enableACME = true;
  };

  systemd.services.uwsgi.personal.monitor = true;
}
