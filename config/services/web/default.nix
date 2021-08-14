{ ... }:

{
  imports = [ ./quentin ./searx ];

  security.acme = {
    acceptTerms = true;
    email = "quentin@aristote.fr";
  };

  services.nginx = {
    enable = true;
    # return 444 when trying to connect directly through the IP address
    virtualHosts."_" = {
      default = true;
      extraConfig = ''
        return 444;
      '';
    };
  };
}
