{...}: {
  imports = [./hardware-configuration.nix];
  personal.hardware.disks.crypted = "/dev/disk/by-uuid/eaec758b-ba22-42ab-8992-e765cec9be55";
}
