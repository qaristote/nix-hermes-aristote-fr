{...}: {
  personal.networking = {
    enable = true;
    firewall.http = true;
    ssh.enable = true;
  };

  networking = {
    hostName = "hermes";
    domain = "aristote.fr";

    useDHCP = false;
    interfaces.ens3.ipv4.addresses = [
      {
        address = "93.95.228.53";
        prefixLength = 24;
      }
    ];
    defaultGateway = "93.95.228.1";
    nameservers = ["93.95.224.28" "93.95.224.29"];

    firewall.allowedUDPPorts = [51820];
    wireguard = {
      enable = true;
      interfaces.talaria = {
        ips = ["10.13.42.1/24"];
        listenPort = 51820;
        privateKeyFile = "/etc/wireguard/talaria.key";
        peers = [
          {
            publicKey = "RrRb7eFxyfOOM99pJyBJ9fOIaZeEllHa8kQheN99dFE=";
            allowedIPs = ["10.13.42.2"];
          }
        ];
      };
    };
  };
}
