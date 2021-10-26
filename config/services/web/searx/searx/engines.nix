let
  overrideDisabled = value: names:
    map (name: {
      inherit name;
      disabled = value;
    }) names;
  enable = overrideDisabled false;
  disable = overrideDisabled true;
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
]) ++ (enable [
  # General
  "duckduckgo"
]) ++ [
  { # AlternativeTo
    name = "alternativeto";
    engine = "xpath";
    paging = true;
    # an invisible whitespace is added at the end of the query to prevent redirections
    search_url = "https://alternativeto.net/browse/search?q={query}%E2%80%8E&p={pageno}";
    results_xpath = ''
      //article[@class="row app-list-item"]/div[@class="col-xs-10 col-sm-10 col-md-11 col-lg-offset-1 col-lg-11"]'';
    url_xpath = "./h3/a/@href";
    title_xpath = "./h3/a";
    content_xpath = ''./div[@class="itemDesc read-more-box"]/p[@class="text"]'';
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
    # an invisible whitespace is added at the end of the query to prevent redirections
    search_url = "https://emojipedia.org/search/?q={query}%E2%80%8E";
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
    name = "nlab";
    engine = "xpath";
    search_url = "https://ncatlab.org/nlab/search?query={query}";
    url_xpath = "//li/a/@href";
    title_xpath = "//li/a";
    content_xpath = "//li/a";
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
]
