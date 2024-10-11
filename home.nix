{ config, lib, pkgs, ... }:

{
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05";

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # System utilities
    bat
    btop
    fd
    gh
    htop
    ripgrep
    libgcc
    libz
    home-manager
    marksman
    unzip
    wget
    silver-searcher
    nix-search-cli
    jq

    # i3
    i3wsr

    # GUI applications
    chromium
    rofi
    xfce.xfce4-terminal
    zathura
    obsidian
    qutebrowser
    st

    # Development tools
    gcc
    python3
    go
    lua51Packages.lua
    lua51Packages.luarocks
    tree-sitter
    nodejs
    cargo
    rustc
    neovim

    # AI tools
    aichat

    # Avante.nvim dependencies
    pkg-config
    openssl.dev
  ];


  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/tomasznanowski/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    EDITOR = "nvim";
    PAGER = "less -FirSwX";
  };


  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  xdg.enable = true;
  xdg.configFile = {
    "i3".source = dotfiles/i3;
    "rofi".source = dotfiles/rofi;
    "i3wsr".source = dotfiles/i3wsr;
    "qutebrowser/config.py".source = dotfiles/qutebrowser.py;
    "i3status".source = dotfiles/i3status;

    "alacritty".source = dotfiles/alacritty;

    "aichat/config.yaml".source = dotfiles/aichat/config.yaml;
    "aichat/roles".source = dotfiles/aichat/roles;

    "nvim/lua".source = dotfiles/nvim/lua;
    "nvim/init.lua".source = dotfiles/nvim/init.lua;
    "nvim/stylua.toml".source = dotfiles/nvim/stylua.toml;
  };

  xresources.extraConfig = builtins.readFile dotfiles/Xresources;

  programs.fish = {
    enable = true;
    interactiveShellInit = builtins.readFile ./dotfiles/fish/config.fish;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
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

  programs.alacritty = {
    enable = true;
  };

  programs.wezterm = {
    enable = true;
    extraConfig = builtins.readFile dotfiles/wezterm.lua;
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = builtins.fromTOML(builtins.readFile dotfiles/starship.toml);
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

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultOptions = [''--height 20% --border''];
  };

  programs.eza = {
    enable = true;
    icons = true;
  };

  programs.autojump = {
    enable = true;
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

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
