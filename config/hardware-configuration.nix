{ lib, modulesPath, ... }:

{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot.initrd.availableKernelModules =
    [ "ata_piix" "uhci_hcd" "virtio_pci" "sr_mod" "virtio_blk" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/2b302948-5608-41c6-b54c-1c0e39ff6a58";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."root".device =
    "/dev/disk/by-uuid/eaec758b-ba22-42ab-8992-e765cec9be55";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/74d78eba-c29a-4724-8fb7-624e0a03faa5";
    fsType = "ext4";
  };

  swapDevices = [{ device = "/swap"; }];

  nix.maxJobs = lib.mkDefault 1;
}
