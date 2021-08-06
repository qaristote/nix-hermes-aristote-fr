{ ... }:

{
  networking = {
    hostName = "hermes.aristote.fr";

    useDHCP = false;
    interfaces.ens3.ipv4.addresses = [{
      address = "93.95.228.53";
      prefixLength = 16;
    }];
    defaultGateway = "93.95.228.1";
    nameservers = [ "93.95.224.28" "93.95.224.29" ];

    firewall = {
      enable = true;
      allowedTCPPorts = [ 80 443 ];
    };
  };

  services.nginx = {
    enable = true;
    virtualHosts = {
      "quentin.aristote.fr" = { root = "${pkgs.personal.academic-webpage}"; };
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
