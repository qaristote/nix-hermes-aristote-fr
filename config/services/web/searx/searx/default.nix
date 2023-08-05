{ config, lib, pkgs, ... }:

let
  cfg = {
    morty = config.services.morty;
    filtron = config.services.filtron;
  };
in {
  imports = [ ./engines.nix ];

  services.searx = {
    enable = true;
    package = pkgs.searxng;

    runInUwsgi = true;
    uwsgiConfig = {
      cache2 = "name=searxcache,items=2000,blocks=2000,blocksize=4096,bitmap=1";
      http = ":${toString cfg.filtron.target.port}";
    };

    environmentFile = /etc/searx/secrets;
    settings = {
      use_default_settings = true;
      general = {
        debug = true;
        contact_url = "mailto:quentin@${config.networking.domain}";
        enable_stats = false;
      };
      search = {
        autocomplete = "wikipedia";
        default_lang = "en-US";
        formats = [ "html" "json" ];
      };
      server = {
        secret_key = "@SECRET_KEY@";
        image_proxy = true;
        http_protocol_version = "1.0";
        method = "GET";
      };
      ui = { theme_args = { oscar_style = "pointhi"; }; };
      result_proxy = lib.mkIf cfg.morty.enable {
        url = "http://searx.${config.networking.domain}/morty";
        key = ''!!binary | "${cfg.morty.key}"'';
      };
      enabled_plugins = [
        "Open Access DOI rewrite"
        "Hash plugin"
        "HTTPS rewrite"
        "Self Informations"
        "Search on category select"
        "Tracker URL remover"
        "Vim-like hotkeys"
      ];
    };
  };

  personal.monitoring.services = [ "searx-init" ];
}
