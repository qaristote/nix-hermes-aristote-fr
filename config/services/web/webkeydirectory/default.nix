{ config, ... }:

let webkeydirectoryPath = "/.well-known/openpgpkey/${config.networking.domain}";
in {
  services.nginx.virtualHosts.webkeydirectory = {
    serverName = "openpgpkey.${config.networking.domain}";
    locations = {
      "${webkeydirectoryPath}/hu/" = {
        alias = ./hu/;
        extraConfig = ''
          default_type        "application/octet-stream";
          add_header          Access-Control-Allow-Origin * always;
        '';
      };
      "=${webkeydirectoryPath}/policy".alias = builtins.toFile "policy" "";
    };
    forceSSL = true;
    enableACME = true;
  };
}
