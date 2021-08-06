{ ... }:

{
  boot = {
    loader.grub = {
      enable = true;
      version = 2;
      enableCryptodisk = true;
      device = "/dev/vda";
    };
  };
}
