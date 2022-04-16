{ ... }:

{
  imports = [ ./money ./quentin ./searx ];

  security.acme = {
    acceptTerms = true;
    defaults.email = "quentin@aristote.fr";
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
    appendHttpConfig = ''
      types_hash_bucket_size 128;
      access_log /dev/null;
    '';
  };
}
