{
  inputs.personal-webpage = {
    url = "github:qaristote/webpage";
    inputs.nixpkgs.follows = "";
  };

  outputs = { self, nixpkgs, ... }@attrs: {
    nixosConfigurations = {
      hermes = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = attrs;
        modules = [ ./configuration.nix ./hardware-configuration.nix ];
      };
      hermes-test = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = attrs;
        modules = [ ./tests/configuration.nix ];
      };
    };
  };
}
