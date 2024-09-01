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
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: let
    # The config files for this system.
    machineConfig = ./machines/vm-aarch64.nix;
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search, run:
      # $ nix search wget
      environment.systemPackages = with pkgs; [
        gnumake
        killall
        xclip
        xorg.libxcvt

        # This is needed for the vmware user tools clipboard to work.
        gtkmm3

        # For hypervisors that support auto-resizing, this script forces it.
        # I've noticed not everyone listens to the udev events so this is a hack.
        (writeShellScriptBin "xrandr-auto" ''
          xrandr --output Virtual-1 --mode 2560x1440
        '')
      ];
      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";
      nix.settings.trusted-users = [ "tomek" ];

      # Set your time zone.
      time.timeZone = "Europe/London";

      # Since we're using fish as our shell
      programs.fish.enable = true;

      # Define a user account. Don't forget to set a password with ‘passwd’.
      users.mutableUsers = false;
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

      # Manage fonts. We pull these from a secret directory since most of these
      # fonts require a purchase.
      fonts = {
        fontDir.enable = true;
        packages = [
          pkgs.fira-code
          pkgs.jetbrains-mono
        ];
      };
    };
  in {
    nixosConfigurations.newton = nixpkgs.lib.nixosSystem {
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
