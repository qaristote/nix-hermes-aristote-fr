{ ... }:

{
  services.ihatemoney = {
    enable = true;
    enableAdminDashboard = true;
    adminHashedPassword =
      "pbkdf2:sha256:150000$s78RCYkJ$9c15a62ed1c89625cb78b5bde87d03b6dd1a03831afa4dbb2abb15ea4c1e150b";
    uwsgiConfig = { http = ":8000"; };
    extraConfig = ''
      APPLICATION_ROOT = "https://quentin.aristote.fr/money/"
    '';
  };

  services.nginx.virtualHosts."quentin.aristote.fr".locations."/money/".proxyPass = "http://127.0.0.1:8000/";
}
