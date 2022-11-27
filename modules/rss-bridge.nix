{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.rss-bridge;
  rss-bridge = pkgs.rss-bridge.overrideAttrs (oldAttrs:
    oldAttrs // {
      installPhase = oldAttrs.installPhase + ''
        pushd $out/bridges
        ln -sf ${./ParisJazzClubBridge.php} ParisJazzClubBridge.php
        ln -sf ${./MaisonDeLaRadioBridge.php} MaisonDeLaRadioBridge.php
        ln -sf ${./FipAlbumsBridge.php} FipAlbumsBridge.php
        ln -sf ${./WhatsOnMubiBridge.php} WhatsOnMubiBridge.php
        popd
      '' + lib.optionalString debug ''
        touch $out/DEBUG
      '';
    });
in {
  options.services.rss-bridge = {
    package = mkOption {
      type = types.package;
      description = "Which derivation to use.";
      default = pkgs.rss-bridge;
      defaultText = literalExample "pkgs.rss-bridge";
    };
    debug = mkEnableOption "debug mode";
    extraBridges = mkOption {
      type = types.listOf (types.submodule {
        options = {
          name = mkOption {
            type = types.strMatching "[a-zA-Z0-9]*";
            description = ''
              The name of the bridge.
              It need not include 'Bridge' at the end, unlike required in RSS-Bridge.
            '';
            example = "SomeAppWithANewsletter";
          };
          source = mkOption {
            type = types.path;
            description = ''
              The path to a file whose contents is the PHP sourcecode of the bridge.
              See also the RSS-Bridge documentation: https://rss-bridge.github.io/rss-bridge/Bridge_API/index.html.
            '';
          };
        };
      });
      default = [ ];
      description = ''
        A list of additional bridges that aren't already included in RSS-Bridge.
        These bridges are automatically whitelisted'';
    };
  };

  config.services.rss-bridge.whitelist =
    map (bridge: bridge.name) cfg.extraBridges;
  config.services.nginx = mkIf (cfg.virtualHost != null) {
    virtualHosts.${cfg.virtualHost}.root = mkIf (cfg.extraBridges != [ ])
      (mkForce (pkgs.runCommand "rss-bridge" { } (''
        mkdir -p $out/bridges
        cp -r ${cfg.package}/* $out/
        pushd $out/bridges 
      '' + concatStrings (map (bridge: ''
        ln -sf ${bridge.source} "${bridge.name}Bridge.php"
      '') cfg.extraBridges) + ''
        popd
      '' + lib.optionalString cfg.debug ''
        touch $out/DEBUG
      '')));
  };
}
