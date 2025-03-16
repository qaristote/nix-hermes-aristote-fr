{
  config,
  lib,
  pkgs,
  ...
}: let
  allowReboot = true;
in {
  personal.nix = {
    enable = true;
    autoUpgrade.enable = true;
    gc.enable = true;
    flake = "git+file:///etc/nixos/";
    remoteBuilds = {
      enable = true;
      machines.hephaistos = {
        enable = true;
        domain = "aristote.mesh";
        user = config.networking.hostName;
      };
    };
  };

  system.autoUpgrade = {inherit allowReboot;};

  # disable remote builds
  nix.settings.max-jobs = 0;
  nixpkgs.flake = {
    setNixPath = true;
    setFlakeRegistry = true;
  };

  systemd.services.nixos-upgrade = {
    preStart = lib.mkForce ''
      cd /etc/nixos
      # requires to have added
      # hephaistos.aristote.mesh:/~/nixos-configuration
      # as remote hephaistos
      git push --force hephaistos master
    '';
    script = lib.mkForce (let
      hephaistos = "hephaistos.aristote.mesh";
    in
      ''
        RESULT=$(ssh ${hephaistos} -- \
          'nix build --print-out-paths \
                     git+file://$(pwd)/nixos-configuration#nixosConfigurations.hermes.config.system.build.toplevel' \
          )
        nix-copy-closure --from ${hephaistos} "$RESULT"
      ''
      + (
        let
          switch = "$RESULT/bin/switch-to-configuration";
          readlink = "${pkgs.coreutils}/bin/readlink";
        in
          if allowReboot
          then ''
            ${switch} boot
            booted="$(${readlink} /run/booted-system/{initrd,kernel,kernel-modules})"
            built="$(${readlink} /nix/var/nix/profiles/system/{initrd,kernel,kernel-modules})"
            if [ "$booted" = "$built" ]
            then
              ${switch} switch
            else
              cryptsetup --verbose luksAddKey \
                         --key-file /etc/luks/keys/master \
                         ${config.boot.initrd.luks.devices.crypt.device} \
                         /etc/luks/keys/tmp
              shutdown -r +1
            fi
          ''
          else ''
            ${switch} switch
          ''
      ));
    serviceConfig = {
      MemoryAccounting = true;
      MemoryHigh = "0.9G";
      MemoryMax = "1G";
      MemorySwapMax = "0";
    };
  };
}
