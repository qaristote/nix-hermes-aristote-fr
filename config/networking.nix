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

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
    extraConfig = ''
      AcceptEnv PS1
    '';
  };
  services.fail2ban.enable = true;
}
