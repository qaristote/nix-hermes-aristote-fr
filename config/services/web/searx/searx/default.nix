{ config, lib, ... }:

let
  cfg = {
    morty = config.services.morty;
    filtron = config.services.filtron;
  };
in {
  services.searx = {
    enable = true;

    runInUwsgi = true;
    uwsgiConfig = {
      cache2 = "name=searxcache,items=2000,blocks=2000,blocksize=4096,bitmap=1";
      http = "http://${cfg.filtron.target.address}:${toString cfg.filtron.target.port}";
    };

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
      ui = { theme_args = { oscar_style = "pointhi"; }; };
      result_proxy = lib.mkIf cfg.morty.enable {
        url = "http://searx.aristote.fr/morty";
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
      engines = let
        disable = names:
          map (name: {
            inherit name;
            disabled = true;
          }) names;
      in (disable [
        # general
        "bing"
        "currency"
        "dictzone"
        # files
        "btdigg"
        "torrentz"
        # images
        "bing images"
        "ccengine"
        "library of congress"
        "qwant images"
        # it
        "hoogle"
        # map
        "photon"
      ]) ++ [
        {
          name = "emojipedia";
          engine = "xpath";
          search_url = "https://emojipedia.org/search/?q={query}";
          url_xpath = ''//ol[@class="search-results"]/li/h2/a/@href'';
          title_xpath = ''//ol[@class="search-results"]/li/h2/a'';
          content_xpath = ''//ol[@class="search-results"]/li/p'';
          shortcut = "emoji";
          disabled = true;
          about = {
            website = "https://emojipedia.org/";
            wikidata_id = "Q22908129";
            official_api_documentation = "";
            use_official_api = false;
            require_api_key = false;
            results = "HTML";
          };
        }
        {
          name = "alternativeTo";
          engine = "xpath";
          paging = true;
          search_url =
            "https://alternativeto.net/browse/search?q={query}&p={pageno}";
          results_xpath = ''
            //article[@class="row app-list-item"]/div[@class="col-xs-10 col-sm-10 col-md-11 col-lg-offset-1 col-lg-11"]'';
          url_xpath = "./h3/a/@href";
          title_xpath = "./h3/a";
          content_xpath =
            ''./div[@class="itemDesc read-more-box"]/p[@class="text"]'';
          shortcut = "a2";
          categories = "it";
          disabled = true;
          about = {
            website = "https://alternativeto.net";
            wikidata_id = "Q3613175";
            official_api_documentation = "";
            use_official_api = false;
            require_api_key = false;
            results = "HTML";
          };
        }
      ];
    };
  };
}
