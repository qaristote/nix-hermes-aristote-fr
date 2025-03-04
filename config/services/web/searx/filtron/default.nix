{...}: {
  services.filtron = {
    enable = true;
    target.port = 8000;
    rules = [
      {
        name = "roboagent limit";
        filters = [
          "Header:User-Agent=(curl|cURL|Wget|python-requests|Scrapy|FeedFetcher|Go-http-client|Ruby|UniversalFeedParser)"
        ];
        limit = 0;
        stop = true;
        actions = [
          {name = "log";}
          {
            name = "block";
            params = {message = "Rate limit exceeded";};
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
          {name = "log";}
          {
            name = "block";
            params = {message = "Rate limit exceeded";};
          }
        ];
      }
      {
        name = "suspiciously frequent IP";
        filters = [];
        interval = 600;
        limit = 30;
        aggregations = ["Header:X-Forwarded-For"];
        actions = [{name = "log";}];
      }
      {
        name = "search request";
        filters = ["Param:q" "Path=^(/|/search)$"];
        interval = 61;
        limit = 999;
        subrules = [
          {
            name = "missing Accept-Language";
            filters = ["!Header:Accept-Language"];
            limit = 0;
            stop = true;
            actions = [
              {name = "log";}
              {
                name = "block";
                params = {message = "Rate limit exceeded";};
              }
            ];
          }
          # {
          #   name = "suspiciously Connection=close header";
          #   filters = [ "Header:Connection=close" ];
          #   limit = 0;
          #   stop = true;
          #   actions = [
          #     { name = "log"; }
          #     {
          #       name = "block";
          #       params = { message = "Rate limit exceeded"; };
          #     }
          #   ];
          # }
          {
            name = "IP limit";
            interval = 61;
            limit = 9;
            stop = true;
            aggregations = ["Header:X-Forwarded-For"];
            actions = [
              {name = "log";}
              {
                name = "block";
                params = {message = "Rate limit exceeded";};
              }
            ];
          }
          {
            name = "rss/json limit";
            filters = ["Param:format=(csv|json|rss)"];
            interval = 121;
            limit = 2;
            stop = true;
            actions = [
              {name = "log";}
              {
                name = "block";
                params = {message = "Rate limit exceeded";};
              }
            ];
          }
          {
            name = "useragent limit";
            interval = 61;
            limit = 199;
            aggregations = ["Header:User-Agent"];
            actions = [
              {name = "log";}
              {
                name = "block";
                params = {message = "Rate limit exceeded";};
              }
            ];
          }
        ];
      }
    ];
  };
}
