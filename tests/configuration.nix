{ config, lib, modulesPath, ... }:

let
  nginxPorts = lib.concatLists
    (lib.mapAttrsToList (_: cfg: (builtins.map (x: x.port) cfg.listen))
      config.services.nginx.virtualHosts);
  nginxMakeLocal = port: {
    listen = lib.mkForce [{
      inherit port;
      addr = "0.0.0.0";
    }];
    forceSSL = lib.mkForce false;
    enableACME = lib.mkForce false;
  };
in {
  imports = [ ../config ];

  boot.isContainer = true;

  networking = lib.mkForce {
    domain = "aristote.vm";

    interfaces = { };
    defaultGateway = null;
    nameservers = [ ];

    firewall = { allowedTCPPorts = nginxPorts; };
  };

  services.filtron.rules = lib.mkForce [ ];

  services.nginx.virtualHosts = {
    quentin = nginxMakeLocal 8080;
    searx = nginxMakeLocal 8081;
    money = nginxMakeLocal 8082;
    rss = nginxMakeLocal 8083;
    webkeydirectory = nginxMakeLocal 8084;
  };

  environment.etc."searx/secrets".text = ''
    SECRET_KEY=secret_key
  '';
}
