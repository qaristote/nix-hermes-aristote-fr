{
  lib,
  pkgs,
  ...
}: {
  personal.nix = {
    enable = true;
    autoUpgrade = {
      enable = true;
      autoUpdateInputs = ["nixpkgs" "nixpkgs-unstable"];
    };
    gc.enable = true;
    flake = "git+file:///etc/nixos/";
  };
  nix.settings.max-jobs = lib.mkDefault 1;
  nixpkgs.flake = {
    setNixPath = true;
    setFlakeRegistry = true;
  };

  systemd.services.nixos-upgrade = let
    mkForce = lib.mkOverride 51;
  in {
    # restart at most once every hour
    serviceConfig = {
      Restart = "on-failure";
      RestartSec = "5sec";
      MemoryAccounting = true;
      MemoryHigh = "1G";
      MemoryMax = "1.5G";
    };
    startLimitBurst = mkForce 1;
    startLimitIntervalSec = mkForce 3600;
    preStart = lib.mkAfter ''
      echo Dry-building...
      drvs=$(${pkgs.nixos-rebuild}/bin/nixos-rebuild dry-build --flake /etc/nixos/ 2>&1 | grep '/nix/store')
      for drv in $drvs
      do
      	case $(echo $drv | cut -d'-' -f2) in
      		gcc | rust | cmake | ghc)
      			echo Found $drv!
      			echo Cancelling build: it is likely to be resource-intensive.
      		       	echo Here are the derivations that were going to be built, and the paths that were going to be downloaded:
      			echo $drvs | tr " " "\n"
      			exit 1
      		;;
      	esac
      done
      echo No resource-intensive building detected, good to go!
    '';
  };
}
