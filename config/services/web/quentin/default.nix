{
  config,
  pkgs,
  ...
}: {
  services.nginx.virtualHosts.quentin = {
    serverName = "quentin.${config.networking.domain}";
    locations."/".root = "${pkgs.personal.webpage}";
    forceSSL = true;
    enableACME = true;
    extraConfig = ''
      add_header Cache-Control no-cache;
      add_header Content-Security-Policy "default-src 'none'; form-action 'none'; frame-ancestors 'none'; font-src 'self'; img-src 'self'; style-src 'self' 'unsafe-inline';";
    '';
  };

  # automatically fetch (non-structural) website updates when updating the system
  personal.nix.autoUpgrade.autoUpdateInputs = ["personal-webpage/data"];
}
