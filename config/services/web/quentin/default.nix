{ config, pkgs, ... }:

{
  services.nginx.virtualHosts.quentin = {
    serverName = "quentin.${config.networking.domain}";
    locations."/".root = "${pkgs.personal.webpage.override {
      line-awesome-css =
        pkgs.personal.line-awesome-css.override { fontDisplay = "swap"; };
    }}";
    forceSSL = true;
    enableACME = true;
  };

  # automatically fetch (non-structural) website updates when updating the system
  system.autoUpgrade.flags = [ "--update-input" "personal-webpage/data" ];
}
