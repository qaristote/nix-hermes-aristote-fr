{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.filtron;
  addressType = types.submodule {
    options = {
      address = mkOption {
        type = types.str;
        default = "127.0.0.1";
      };
      port = mkOption { type = types.port; };
    };
  };
in {
  options.services.filtron = {
    enable = mkEnableOption { name = "filtron"; };
    package = mkOption {
      type = types.package;
      default = pkgs.personal.filtron;
      defaultText = literalExample "pkgs.personal.filtron";
      description = ''
        The package containing the filtron executable.
      '';
    };
    api = mkOption {
      type = addressType;
      default = { address = "localhost"; port = 4005; };
      description = ''
        API listen address and port.
      '';
    };
    listen = mkOption {
      type = addressType;
      default = { port = 4004; };
      description = ''
        Proxy listen address and port.
      '';
    };
    target = mkOption {
      type = addressType;
      default = { port = 8888; };
      description = ''
        Target address and port for reverse proxy.
      '';
    };
    rules = mkOption {
      type = with types; listOf (attrsOf anything);
      description = ''
        Rule list.
      '';
    };
    readBufferSize = mkOption {
      type = types.int;
      default = 16384;
      description = ''
        Size of the buffer used for reading.
      '';
    };
  };

  config = mkIf cfg.enable {
    users.users.filtron = {
      description = "Filtron daemon user";
      group = "filtron";
      isSystemUser = true;
    };
    users.groups.filtron = { };

    systemd.services.filtron = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      description = "Start a filtron instance.";
      serviceConfig = {
        User = "filtron";
        ExecStart = with builtins; ''
          ${cfg.package}/bin/filtron \
                  -rules ${toFile "filtron-rules.json" (toJSON cfg.rules)} \
                  -api "${cfg.api.address}:${toString cfg.api.port}" \
                  -listen "${cfg.listen.address}:${toString cfg.listen.port}" \
                  -target "${cfg.target.address}:${toString cfg.target.port}" \
                  -read-buffer-size ${toString cfg.readBufferSize}
        '';
      };
    };
  };
}
