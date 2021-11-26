{ config, pkgs, ... }:

{
  services.nginx.virtualHosts."quentin.${config.networking.domain}" = {
    locations."/".root = "${pkgs.personal.academic-webpage}";
    forceSSL = true;
    enableACME = true;
  };
}
