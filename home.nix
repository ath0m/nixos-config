{ config, lib, pkgs, pkgsUnstable, ... }:

{
  # Home-manager 22.11 requires this be set. We never set it so we have
  # to use the old state version.
  home.stateVersion = "24.05";

  # Packages I always want installed. Most packages I install using
  # per-project flakes sourced with direnv and nix-shell, so this is
  # not a huge list.
  home.packages = [
    pkgs.bat
    pkgs.fd
    pkgs.fzf
    pkgs.gh
    pkgs.htop
    pkgs.ripgrep
    pkgs.chromium
    pkgs.rofi
    pkgs.xfce.xfce4-terminal
    pkgs.libgcc
    pkgs.home-manager
    pkgs.unzip
    pkgs.wget
    pkgs.aichat

    pkgs.gcc
    pkgs.python3
    pkgs.go
    pkgs.lua
    pkgs.luarocks
    pkgs.tree-sitter
    pkgs.nodejs
    pkgs.cargo
    pkgsUnstable.rustc
    pkgsUnstable.neovim
  ];

  #---------------------------------------------------------------------
  # Env vars and dotfiles
  #---------------------------------------------------------------------

  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    EDITOR = "nvim";
    PAGER = "less -FirSwX";
  };

  home.file.".inputrc".source = ./dotfiles/inputrc;

  xdg.enable = true;
  xdg.configFile = {
    "i3/config".text = builtins.readFile ./dotfiles/i3;
    "rofi/config.rasi".text = builtins.readFile ./dotfiles/rofi;
    "starship/config.toml".text = builtins.readFile ./dotfiles/starship.toml;
  };

  xresources.extraConfig = builtins.readFile ./dotfiles/Xresources;

  #---------------------------------------------------------------------
  # Programs
  #---------------------------------------------------------------------

  programs.fish = {
    enable = true;
    interactiveShellInit = lib.strings.concatStrings (lib.strings.intersperse "\n" ([
      (builtins.readFile ./dotfiles/config.fish)
      "set -g SHELL ${pkgs.fish}/bin/fish"
      "source ~/.secrets.fish"
    ]));
  };

  programs.git = {
    enable = true;
    userName = "Tomasz Nanowski";
    userEmail = "tomasz.nanowski@gmail.com";
    extraConfig = {
      branch.autosetuprebase = "always";
      color.ui = true;
      init.defaultBranch = "main";
    };
  };

  programs.wezterm = {
    enable = true;
    extraConfig = builtins.readFile ./dotfiles/wezterm.lua;
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.lazygit = {
    enable = true;
  };

  programs.atuin = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      search_mode = "fuzzy";
      filter_mode_shell_up_key_binding = "session";
      style = "compact";
      show_preview = true;
      exit_mode = "return-original";
      secrets_filter = false;
    };
  };

  programs.eza = {
    enable = true;
    icons = true;
  };

  programs.i3status = {
    enable = true;

    general = {
      colors = true;
      color_good = "#8C9440";
      color_bad = "#A54242";
      color_degraded = "#DE935F";
    };

    modules = {
      ipv6.enable = false;
      "wireless _first_".enable = false;
      "battery all".enable = false;
    };
  };

  # Make cursor not tiny on HiDPI screens
  # home.pointerCursor = {
  #   name = "Vanilla-DMZ";
  #   package = pkgs.vanilla-dmz;
  #   size = 128;
  #   x11.enable = true;
  # };
}
