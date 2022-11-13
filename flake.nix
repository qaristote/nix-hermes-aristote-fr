{
  inputs = {
    personal-webpage = {
      url = "github:qaristote/webpage";
      inputs = {
        nixpkgs.follows = "/nixpkgs";
        flake-utils.follows = "/flake-utils";
      };
    };
  };

  outputs = { self, nixpkgs, personal-webpage, flake-utils, ... }@attrs:
    flake-utils.lib.eachDefaultSystem (system: {
      overlays.default = final: prev: {
        personal = import ./pkgs { pkgs = final; } // {
          webpage = personal-webpage.defaultPackage."${system}";
        };
      };
    }) // {
      nixosModules.default = import ./modules;
      nixosConfigurations = let
        system = "x86_64-linux";
        specialArgs = attrs;
        commonModules = [
          self.nixosModules.default
          ({ ... }: {
            nixpkgs.overlays = [ self.overlays."${system}".default ];
          })
        ];
      in {
        hermes = nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
          modules = commonModules ++ [ ./config ./hardware-configuration.nix ];
        };
        hermes-test = nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
          modules = commonModules ++ [ ./tests/configuration.nix ];
        };
      };
    };
}
