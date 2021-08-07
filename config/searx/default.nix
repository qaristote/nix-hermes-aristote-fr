{ pkgs, lib, config, ... }:

let
  ports = {
    searx = 8888;
    filtron = {
      listen = 4004;
      api = 4005;
    };
    morty = 3000;
  };
  keys = { morty = "1t/rvXuoX/9OKwZ6Zby1zBc5t1DRFYIiE15xhIi72TKX"; };
in {
  # Nginx
  services.nginx.virtualHosts."searx.aristote.fr" = {
    locations = {
      "/" = {
        proxyPass = "http://127.0.0.1:${toString ports.filtron.listen}";
        extraConfig = ''
          proxy_set_header Host            $host;
          proxy_set_header Connection      $http_connection;
          proxy_set_header X-Real-IP       $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Scheme        $scheme;
          # proxy_set_header X-Script-Name   /;
        '';
      };
      "/static/" = { alias = "${pkgs.searx}/share/static/"; };
      "/morty" = lib.mkIf (config.services.morty.enable) {
        proxyPass = "http://127.0.0.1:${toString ports.morty}";
        extraConfig = ''
          proxy_set_header Host            $host;
          proxy_set_header Connection      $http_connection;
          proxy_set_header X-Real-IP       $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Scheme        $scheme;
        '';
      };
    };
  };

  # Searx
  services.searx = {
    enable = true;
    environmentFile = /etc/searx/secrets;
    settings = {
      use_default_settings = true;
      general = {
        debug = false;
        contact_url = "mailto:quentin@aristote.fr";
        enable_stats = false;
      };
      search = {
        autocomplete = "dbpedia";
        default_lang = "fr-FR";
      };
      server = {
        secret_key = "@SECRET_KEY@";
        image_proxy = true;
        http_protocol_version = "1.0";
        method = "GET";
      };
      ui = {
        # default_locale = "fr";
        theme_args = { oscar_style = "pointhi"; };
      };
      # result_proxy = {
      #   url = "http://searx.aristote.fr/morty";
      #   key = ''!!binary | "${keys.morty}"'';
      # };
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
    runInUwsgi = true;
    uwsgiConfig = {
      cache2 = "name=searxcache,items=2000,blocks=2000,blocksize=4096,bitmap=1";
      http = ":${toString ports.searx}";
    };
  };

  # Filtron
  services.filtron = {
    enable = true;
    rules = [
      {
        name = "roboagent limit";
        filters = [
          "Header:User-Agent=(curl|cURL|Wget|python-requests|Scrapy|FeedFetcher|Go-http-client|Ruby|UniversalFeedParser)"
        ];
        limit = 0;
        stop = true;
        actions = [
          { name = "log"; }
          {
            name = "block";
            params = { message = "Rate limit exceeded"; };
          }
        ];
      }
      {
        name = "botlimit";
        filters = [
          "Header:User-Agent=(Googlebot|bingbot|Baiduspider|yacybot|YandexMobileBot|YandexBot|Yahoo! Slurp|MJ12bot|AhrefsBot|archive.org_bot|msnbot|MJ12bot|SeznamBot|linkdexbot|Netvibes|SMTBot|zgrab|James BOT)"
        ];
        limit = 0;
        stop = true;
        actions = [
          { name = "log"; }
          {
            name = "block";
            params = { message = "Rate limit exceeded"; };
          }
        ];
      }
      {
        name = "suspiciously frequent IP";
        filters = [ ];
        interval = 600;
        limit = 30;
        aggregations = [ "Header:X-Forwarded-For" ];
        actions = [{ name = "log"; }];
      }
      {
        name = "search request";
        filters = [ "Param:q" "Path=^(/|/search)$" ];
        interval = 61;
        limit = 999;
        subrules = [
          {
            name = "missing Accept-Language";
            filters = [ "!Header:Accept-Language" ];
            limit = 0;
            stop = true;
            actions = [
              { name = "log"; }
              {
                name = "block";
                params = { message = "Rate limit exceeded"; };
              }
            ];
          }
          {
            name = "suspiciously Connection=close header";
            filters = [ "Header:Connection=close" ];
            limit = 0;
            stop = true;
            actions = [
              { name = "log"; }
              {
                name = "block";
                params = { message = "Rate limit exceeded"; };
              }
            ];
          }
          {
            name = "IP limit";
            interval = 61;
            limit = 9;
            stop = true;
            aggregations = [ "Header:X-Forwarded-For" ];
            actions = [
              { name = "log"; }
              {
                name = "block";
                params = { message = "Rate limit exceeded"; };
              }
            ];
          }
          {
            name = "rss/json limit";
            filters = [ "Param:format=(csv|json|rss)" ];
            interval = 121;
            limit = 2;
            stop = true;
            actions = [
              { name = "log"; }
              {
                name = "block";
                params = { message = "Rate limit exceeded"; };
              }
            ];
          }
          {
            name = "useragent limit";
            interval = 61;
            limit = 199;
            aggregations = [ "Header:User-Agent" ];
            actions = [
              { name = "log"; }
              {
                name = "block";
                params = { message = "Rate limit exceeded"; };
              }
            ];
          }
        ];
      }
    ];
  };

  # Morty
  # services.morty = {
  #   enable = true;
  #   key = keys.morty;
  #   port = ports.morty;
  # };
}
