{ lib, ... }:

with lib;
let
  overrideDisabled = value: names:
    map (name: {
      inherit name;
      disabled = value;
    }) names;
  enable = overrideDisabled false;
  disable = overrideDisabled true;

  makeSearchUrl = { baseUrl, queryKeyword ? "query", pageKeyword ? null
    , preventRedirect ? false, extraParameters ? { } }:
    baseUrl + "?${queryKeyword}={query}"
    # an invisible whitespace is added at the end of the query to prevent redirections
    + (optionalString preventRedirect "%E2%80%8E")
    + (optionalString (pageKeyword != null) "&${pageKeyword}={pageno}")
    + (concatStrings
      (mapAttrsToList (name: value: "&${name}=${builtins.toString value}")
        extraParameters));

  wikipediaSearch = lang: {
    name = "wikipedia search ${lang}";
    engine = "xpath";
    search_url = makeSearchUrl {
      baseUrl = "https://${lang}.wikipedia.org/w/index.php";
      queryKeyword = "search";
      extraParameters = { fulltext = 1; };
    };
    results_xpath = ''//ul[@class="mw-search-results"]/li'';
    url_xpath = ''./div[@class="mw-search-result-heading"]/a/@href'';
    title_xpath = ''./div[@class="mw-search-result-heading"]/a'';
    content_xpath = ''./div[@class="searchresult"]'';
    shortcut = "w${lang}";
    categories = "general";
    disabled = true;
    about = {
      website = "https://${lang}.wikipedia.org/";
      wikidata_id = "Q52";
      official_api_documentation = "https://${lang}.wikipedia.org/api/";
      use_official_api = false;
      require_api_key = false;
      results = "HTML";
    };
  };
in {
  services.searx.settings.engines = (disable [
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
  ]) ++ (enable [
    # general
    "duckduckgo"
  ]) ++ [
    { # AlternativeTo
      name = "alternativeto";
      engine = "xpath";
      paging = true;
      search_url = makeSearchUrl {
        baseUrl = "https://alternativeto.net/browse/search";
        queryKeyword = "q";
        pageKeyword = "p";
        preventRedirect = true;
      };
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
        website = "https://alternativeto.net/";
        wikidata_id = "Q3613175";
        official_api_documentation = "";
        use_official_api = false;
        require_api_key = false;
        results = "HTML";
      };
    }
    { # Emojipedia
      name = "emojipedia";
      engine = "xpath";
      search_url = makeSearchUrl {
        baseUrl = "https://emojipedia.org/search/";
        queryKeyword = "q";
      };
      results_xpath = ''//ol[@class="search-results"]/li'';
      url_xpath = "./h2/a/@href";
      title_xpath = "./h2/a";
      content_xpath = "./p";
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
      name = "nlab";
      engine = "xpath";
      search_url =
        makeSearchUrl { baseUrl = "https://ncatlab.org/nlab/search"; };
      results_xpath = "//li/a";
      url_xpath = "./@href";
      title_xpath = ".";
      content_xpath = ".";
      shortcut = "nlab";
      timeout = 10.0;
      categories = "science";
      disabled = true;
      about = {
        website = "https://ncatlab.org/";
        wikidata_id = "Q6954693";
        official_api_documentation = "";
        use_official_api = false;
        require_api_key = false;
        results = "HTML";
      };
    }
  ] ++ (map wikipediaSearch [ "fr" "en" ]);
}
