{
  description = "NixOS systems and tools";

  inputs = {
    # Pin our primary nixpkgs repository. This is the main nixpkgs repository
    # we'll use for our configurations. Be very careful changing this because
    # it'll impact your entire system.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

    # We use the unstable nixpkgs repo for some packages.
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: let
    name = "vm-aarch64";
    system = "aarch64-linux";
    user = "tomek";

    # The config files for this system.
    machineConfig = ./machines/${name}.nix;
    userOSConfig = ./users/${user}/nixos.nix;
    userHMConfig = ./users/${user}/home-manager.nix;

    # NixOS
    systemFunc = nixpkgs.lib.nixosSystem;
    home-manager = inputs.home-manager.nixosModules;
  in {
    nixosConfigurations.vm-aarch64 = systemFunc {
      inherit system;

      modules = [
        machineConfig
        userOSConfig
        home-manager.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${user} = import userHMConfig {
            inputs = inputs;
          };
        }

        # We expose some extra arguments so that our modules can parameterize
        # better based on these values.
        {
          config._module.args = {
            currentSystem = system;
            currentSystemName = name;
            currentSystemUser = user;
            inputs = inputs;
          };
        }
      ];
    };
  };
}
