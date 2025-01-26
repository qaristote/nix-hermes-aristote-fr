{...}: {
  programs.ssh = {
    extraConfig = ''
      Host hephaistos.aristote.mesh
        # Prevent using ssh-agent or another keyfile, useful for testing
        IdentitiesOnly yes
        IdentityFile /etc/ssh/nixremote
        # The weakly privileged user on the remote builder – if not set, 'root' is used – which will hopefully fail
        User nixremote
    '';
    knownHosts."hephaistos.aristote.mesh".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHvtqi8tziBuviUV8LDK2ddQQUbHdJYB02dgWTK5Olxq";
  };

  nix = {
    distributedBuilds = true;
    buildMachines = [
      {
        hostName = "hephaistos.aristote.mesh";
        system = "x86_64-linux";
        # Nix custom ssh-variant that avoids lots of "trusted-users" settings pain
        protocol = "ssh-ng";
        maxJobs = 4;
        speedFactor = 4;
        supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
        mandatoryFeatures = [];
      }
    ];
  };
}
