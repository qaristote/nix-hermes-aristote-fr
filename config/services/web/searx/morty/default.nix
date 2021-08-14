{ config, lib, ... }:

let cfg = config.services.morty;
in {
  services.nginx.virtualHosts."searx.aristote.fr".locations =
    lib.mkIf cfg.enable {
      "/morty/" = {
        proxyPass = "http://127.0.0.1:${toString cfg.port}";
        extraConfig = ''
          proxy_set_header Host            $host;
          proxy_set_header Connection      $http_connection;
          proxy_set_header X-Real-IP       $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Scheme        $scheme;
        '';
      };
    };

  services.morty = {
    enable = false;
  };
}
