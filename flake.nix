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
    # The config files for this system.
    machineConfig = ./machines/vm-aarch64.nix;
    configuration = { pkgs, ... }: {
      # Add ~/.local/bin to PATH
      environment.localBinInPath = true;

      # Since we're using fish as our shell
      programs.fish.enable = true;

      users.users.tomek = {
        isNormalUser = true;
        home = "/home/tomek";
        extraGroups = [ "docker" "wheel" ];
        shell = pkgs.fish;
        hashedPassword = "$y$j9T$nmx.5c9dOnNg4ksj3b8gg/$INJG7iF2jfBYD/15oCQr/tUV4aoH8cX5lEgDUenw.Y0";
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII94r7GTR92EGcu/gj9WwRkUJ/2gQ0qro4rxROUuywGM tomasznanowski@gmail.com"
        ];
      };
    };
  in {
    nixosConfigurations.vm-aarch64 = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";

      modules = [
        machineConfig
        configuration
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.tomek = import ./home.nix;
        }
      ];
    };
  };
}
