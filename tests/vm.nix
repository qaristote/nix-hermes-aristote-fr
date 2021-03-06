{ config, lib, ... }:

let
  nginxPorts = lib.concatLists
    (lib.mapAttrsToList (_: cfg: (builtins.map (x: x.port) cfg.listen))
      config.services.nginx.virtualHosts);
in {
  imports = [ ../configuration.nix ];

  networking = lib.mkForce {
    domain = "aristote.vm";

    interfaces = { };
    defaultGateway = null;
    nameservers = [ ];

    firewall = { allowedTCPPorts = nginxPorts; };
  };

  services.filtron.rules = lib.mkForce [];

  services.nginx.virtualHosts = {
    quentin = {
      listen = lib.mkForce [{
        addr = "0.0.0.0";
        port = 8080;
      }];
      forceSSL = lib.mkForce false;
      enableACME = lib.mkForce false;
    };
    searx = {
      listen = lib.mkForce [{
        addr = "0.0.0.0";
        port = 8081;
      }];
      forceSSL = lib.mkForce false;
      enableACME = lib.mkForce false;
    };
    money = {
      listen = lib.mkForce [{
        addr = "0.0.0.0";
        port = 8082;
      }];
      forceSSL = lib.mkForce false;
      enableACME = lib.mkForce false;
    };
    rss = {
      listen = lib.mkForce [{
        addr = "0.0.0.0";
        port = 8083;
      }];
      forceSSL = lib.mkForce false;
      enableACME = lib.mkForce false;
    };
  };

  environment.etc."searx/secrets".text = ''
    SECRET_KEY=secret_key
  '';
}
