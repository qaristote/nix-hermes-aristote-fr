{ config, pkgs, ... }:
{
  services.nginx = {
    additionalModules = [ pkgs.nginxModules.subsFilter ];
    virtualHosts.git = {
      serverName = "git.${config.networking.domain}";
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://hephaistos.aristote.mesh/git/";
        extraConfig = ''
          proxy_redirect default;
          # fix internal hyperlinks
          proxy_set_header Accept-Encoding ""; 
          sub_filter_once off;
          sub_filter 'href=\'/git/' 'href=\'/';
          sub_filter 'action=\'/git/' 'action=\'/';
        '';
      };
    };
  };
}
