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

    # reroute SSH on port 42137 to hephaistos
    nat.enable = true;
    nftables = {
      enable = true;
      ruleset = ''
        table ip nat {
          chain pre {
            type nat hook prerouting priority dstnat; policy accept;
            iifname "ens3" tcp dport 42137 dnat to 100.64.0.3:22
          }
          chain post {
            type nat hook postrouting priority srcnat; policy accept;
            iifname "ens3" ip daddr 100.64.0.3 tcp dport 22 masquerade
          }
        }
      '';
    };

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
