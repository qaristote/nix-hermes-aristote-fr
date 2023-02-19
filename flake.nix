{
  inputs = {
    personal-webpage = {
      url = "github:qaristote/webpage";
      inputs.nixpkgs.follows = "/nixpkgs";
    };
    my-nixpkgs.url = "github:qaristote/my-nixpkgs";
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
              personal-webpage.overlays.default
              # TODO the order shouldn't matter, yet this overlay doesn't work
              # if it comes first
              my-nixpkgs.overlays.default
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
