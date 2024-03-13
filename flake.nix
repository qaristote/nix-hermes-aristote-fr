{
  inputs = {
    personal-webpage = {
      url = "github:qaristote/webpage";
      inputs.nixpkgs.follows = "/nixpkgs";
    };
    my-nixpkgs.url = "github:qaristote/my-nixpkgs";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11-small";
  };

  outputs =
    { self, nixpkgs, my-nixpkgs, personal-webpage, ... }: {
      nixosConfigurations = let
        system = "x86_64-linux";
        commonModules = [
          my-nixpkgs.nixosModules.personal
          ({ ... }: {
            nixpkgs.overlays = [
              (self: _: { personal = { inherit (personal-webpage.packages."${self.system}") webpage; };})
              # TODO the order shouldn't matter, yet this overlay doesn't work
              # if it comes first
              my-nixpkgs.overlays.personal
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
