{
  inputs = {
    personal-webpage = {
      url = "github:qaristote/webpage";
      inputs.nixpkgs.follows = "/nixpkgs";
    };
    my-nixpkgs.url = "git+file:///home/qaristote/code/nix/my-nixpkgs";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11-small";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable-small";
  };

  outputs =
    { self, nixpkgs, nixpkgs-unstable, my-nixpkgs, personal-webpage, ... }: {
      nixosConfigurations = let
        system = "x86_64-linux";
        commonModules = [
          my-nixpkgs.nixosModules.personal
          ({ ... }: {
            nixpkgs.overlays = [
              my-nixpkgs.overlays.personal
              personal-webpage.overlays.default
              (_: prev: {
                inherit (nixpkgs-unstable.legacyPackages."${prev.system}")
                  filtron;
              })
            ];
          })
        ];
      in {
        hermes = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = commonModules
            ++ [ ./config ./config/hardware-configuration.nix ];
        };
        hermes-test = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = commonModules ++ [ ./tests/configuration.nix ];
        };
      };
    };
}
