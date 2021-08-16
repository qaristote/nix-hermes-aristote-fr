{ lib, config, ... }:

let cfg = config.services.ihatemoney;
in {
  services.nginx.virtualHosts."money.aristote.fr" = lib.mkIf cfg.enable {
    forceSSL = true;
    enableACME = true;
    "/".proxyPass = "http://127.0.0.1${cfg.uwsgiConfig.http}/";
  };

  services.ihatemoney = {
    enable = true;
    enableAdminDashboard = true;
    adminHashedPassword =
      "pbkdf2:sha256:150000$s78RCYkJ$9c15a62ed1c89625cb78b5bde87d03b6dd1a03831afa4dbb2abb15ea4c1e150b";
    uwsgiConfig = { http = ":8000"; };
  };

  services.opensmtpd = lib.mkIf cfg.enable {
    enable = true;
    serverConfiguration = ''
      listen on lo
      action block mda "cat >/dev/null"
      match from any for any action block
    '';
  };
}
