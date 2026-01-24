{
  config,
  lib,
  ...
}:
let
  cfg = config.services.headscale;
  url = "mesh.${config.networking.domain}";
in
{
  networking.firewall.allowedUDPPorts = [ 3478 ];

  services.headscale = {
    enable = true;
    port = 8001;
    settings = {
      server_url = "https://${url}:443";
      derps = {
        server = {
          enabled = true;
          stun_listen_addr = "0.0.0.0:3478";
        };
        urls = [ ];
      };
      dns = {
        base_domain = "aristote.mesh";
        override_local_dns = false;
      };
    };
  };

  services.nginx.virtualHosts.mesh = lib.mkIf cfg.enable {
    serverName = "${url}";
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://${cfg.address}:${toString cfg.port}";
      proxyWebsockets = true;
      extraConfig = ''
        proxy_set_header Host $server_name;
        proxy_redirect http:// https://;
        proxy_buffering off;
        add_header Strict-Transport-Security "max-age=15552000; includeSubDomains" always;
      '';
    };
  };
}
