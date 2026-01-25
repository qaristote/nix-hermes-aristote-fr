{ ... }:

{
  imports = [
    ./git
    ./quentin
    ./rss
    ./searx
    ./webkeydirectory
  ];

  security.acme = {
    acceptTerms = true;
    defaults.email = "quentin@aristote.fr";
  };

  services.nginx = {
    enable = true;
    # return 444 when trying to connect to some unknown virtual host
    virtualHosts."_" = {
      default = true;
      extraConfig = ''
        return 444;
      '';
    };
  };
  systemd.services.nginx.personal.monitor = true;
}
