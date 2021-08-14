{ pkgs, lib, config, ... }:

{
  import = [
    ./ihatemoney
  ];

  services.nginx.virtualHosts."quentin.aristote.fr" = {
    locations."/".root = "${pkgs.personal.academic-webpage}";
    forceSSL = true;
    enableACME = true;
  };
}
