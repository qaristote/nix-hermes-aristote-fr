{
  inputs = {
    personal-webpage = {
      url = "github:qaristote/webpage";
      inputs.nixpkgs.follows = "/nixpkgs";
    };
    my-nixpkgs.url = "git+file:///home/qaristote/code/nix/my-nixpkgs";
  };

  outputs = { self, nixpkgs, my-nixpkgs, personal-webpage, ... }: {
    nixosConfigurations = let
      system = "x86_64-linux";
      commonModules = [
        my-nixpkgs.nixosModules.personal
        ({ ... }: {
          nixpkgs.overlays =
            [ my-nixpkgs.overlays.personal personal-webpage.overlays.default ];
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
