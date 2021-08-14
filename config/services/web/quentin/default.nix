{ pkgs, lib, config, ... }:

{
  imports = [ ./ihatemoney ];

  services.nginx.virtualHosts."quentin.aristote.fr" = {
    locations."/".root = "${pkgs.personal.academic-webpage}";
    forceSSL = true;
    enableACME = true;
  };
}
