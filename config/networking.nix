{ ... }:
{
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
    nameservers = [
      "93.95.224.28"
      "93.95.224.29"
    ];
  };

  services.resolved = {
    enable = true;
    dnsovertls = "opportunistic";
  };

  services.tailscale = {
    enable = true;
    openFirewall = true;
    disableTaildrop = true;
  };
}
