{ pkgs, ... }:

{
  networking = {
    hostName = "hermes";
    domain = "aristote.fr";

    useDHCP = false;
    interfaces.ens3.ipv4.addresses = [{
      address = "93.95.228.53";
      prefixLength = 24;
    }];
    defaultGateway = "93.95.228.1";
    nameservers = [ "93.95.224.28" "93.95.224.29" ];

    firewall = {
      enable = true;
      allowedTCPPorts = [ 80 443 ];
    };
  };

  security.acme = {
    acceptTerms = true;
    email = "quentin@aristote.fr";
  };

  services.nginx = {
    enable = true;
    virtualHosts = {
      # return 444 when trying to connect directly through the IP address
      "_" = {
        default = true;
        extraConfig = ''
          return 444;
        '';
      };

      "quentin.aristote.fr" = {
        locations."/".root = "${pkgs.personal.academic-webpage}";
        forceSSL = true;
        enableACME = true;
      };
    };
  };

  services.openssh = {
    enable = true;
    permitRootLogin = "no";
    passwordAuthentication = false;
    extraConfig = ''
      AcceptEnv PS1
    '';
  };
  services.fail2ban.enable = true;
}
