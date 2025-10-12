{ pkgs, ... }:

{
  imports = [
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
    additionalModules = [ pkgs.nginxModules.brotli ];
    # return 444 when trying to connect directly through the IP address
    virtualHosts."_" = {
      default = true;
      extraConfig = ''
        return 444;
      '';
    };
    appendHttpConfig = ''
      types_hash_bucket_size 128;
      access_log /dev/null;

      # compression
      gzip on;
      gzip_vary on;
      gzip_proxied any;
      gzip_comp_level 6;
      gzip_types text/plain text/css text/xml application/json application/javascript application/xml+rss application/atom+xml image/svg+xml;
      brotli on;
      brotli_comp_level 6;
      brotli_types text/xml image/svg+xml application/x-font-ttf image/vnd.microsoft.icon application/x-font-opentype application/json font/eot application/vnd.ms-fontobject application/javascript font/otf application/xml application/xhtml+xml text/javascript application/x-javascript text/plain application/x-font-truetype application/xml+rss image/x-icon font/opentype text/css image/x-win-bitmap;
    '';
  };

  systemd.services.nginx.personal.monitor = true;
}
