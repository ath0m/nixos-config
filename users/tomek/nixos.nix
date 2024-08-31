{ pkgs, inputs, ... }:

{
  # https://github.com/nix-community/home-manager/pull/2408
  environment.pathsToLink = [ "/share/fish" ];

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
}
