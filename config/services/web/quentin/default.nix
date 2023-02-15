{ config, pkgs, ... }:

{
  services.nginx.virtualHosts.quentin = {
    serverName = "quentin.${config.networking.domain}";
    locations."/".root = "${pkgs.personal.webpage}";
    forceSSL = true;
    enableACME = true;
  };

  # automatically fetch (non-structural) website updates when updating the system
  system.autoUpgrade.flags = [ "--update-input" "personal-webpage/data" ];
}
