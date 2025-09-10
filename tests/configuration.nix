{
  config,
  lib,
  ...
}:
let
  nginxPorts = lib.concatLists (
    lib.mapAttrsToList (
      _: cfg: (builtins.map (x: x.port) cfg.listen)
    ) config.services.nginx.virtualHosts
  );
  nginxMakeLocal = port: {
    listen = lib.mkForce [
      {
        inherit port;
        addr = "0.0.0.0";
      }
    ];
    forceSSL = lib.mkForce false;
    enableACME = lib.mkForce false;
  };
in
{
  imports = [ ../config ];

  boot.isContainer = true;

  networking = lib.mkForce {
    domain = "aristote.vm";

    interfaces = { };
    defaultGateway = null;
    nameservers = [ ];

    firewall = {
      allowedTCPPorts = nginxPorts;
    };
  };

  services.resolved.enable = lib.mkForce false;

  services.filtron.rules = lib.mkForce [ ];

  services.rss-bridge.debug = true;

  services.headscale.settings.server_url = lib.mkForce "http://10.233.1.2:8085/";

  services.nginx.virtualHosts = {
    quentin = nginxMakeLocal 8080;
    searx = nginxMakeLocal 8081;
    rss = nginxMakeLocal 8083;
    webkeydirectory = nginxMakeLocal 8084;
    mesh = nginxMakeLocal 8085;
  };

  environment.etc = {
    "searx/secrets".text = ''
      SECRET_KEY=secret_key
    '';
    "msmtp/secrets".text = ''
      password
    '';
  };
}
