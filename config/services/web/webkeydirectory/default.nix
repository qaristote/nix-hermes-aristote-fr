{ config, ... }:

{
  services.nginx.virtualHosts.webkeydirectory = {
    serverName = "openpgpkey.${config.networking.domain}";
    locations."/.well-known/openpgpkey/${config.networking.domain}/hu/" = {
root = null;
    default_type = "application/octet-stream";
    add_header = Access-Control-Allow-Origin * always;
}
    forceSSL = true;
    enableACME = true;
  };
}
