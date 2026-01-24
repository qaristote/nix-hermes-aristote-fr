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

  services.nginx.enable = true;
  systemd.services.nginx.personal.monitor = true;
}
