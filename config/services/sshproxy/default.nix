{ config, pkgs, ... }:
{
  users.users.sshjump = {
    shell = "${pkgs.coreutils}/bin/true";
    isSystemUser = true;
    group = "sshjump";
    openssh.authorizedKeys.keys = with config.personal.lib.publicKeys.ssh; [
      latitude-7490
      precision-3571
      dragonfly-g4
      optiplex-9030
    ];
  };

  users.groups.sshjump = { };

  services.openssh.extraConfig = ''
    Match user sshjump
      AllowTcpForwarding yes
      AllowAgentForwarding yes
      PasswordAuthentication no
      PermitTunnel no
      GatewayPorts no
      PermitTTY no
      X11Forwarding no
  '';
}
