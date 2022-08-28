{ config, ... }:

let webkeydirectoryPath = "/.well-known/openpgpkey/${config.networking.domain}";
in {
  services.nginx.virtualHosts.webkeydirectory = {
    serverName = "openpgpkey.${config.networking.domain}";
    locations."${webkeydirectoryPath}/hu/" = {
      root = ./hu;
      extraConfig = ''
        default_type        "application/octet-stream";
        add_header          Access-Control-Allow-Origin * always;
      '';
    };
    locations."${webkeydirectoryPath}/policy".root = toFile policy "";
    forceSSL = true;
    enableACME = true;
  };
}
