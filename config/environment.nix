{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ vim gitMinimal ];
  programs.bash.promptInit = ''
    PS1="\n\[\033[1;32m\][\[\e]0;\u@$(hostname -f): \w\a\]\u@$(hostname -f):\w]\$\[\033[0m\] "
  '';

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "fr";
  };

  time.timeZone = "Europe/Paris";
}
