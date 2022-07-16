{ lib, pkgs, overlays, nh, xresources, ... }:

{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "discord"
    "gitkraken"
    "unityhub"
  ];
  nixpkgs.overlays = overlays;

  home = {
    username = "tntman";
    homeDirectory = "/home/tntman";

    stateVersion = "22.05";

    packages = with pkgs; [
      # General
      firefox
      alacritty
      easyeffects
      simple-scan
      (discord.override { nss = nss_latest; }) # nss is needed for links
      gitkraken
      rofi
      neovim-nightly
      neovide
      libresprite

      # CLI utils
      atuin
      nh.packages.${system}.default
      unzip
      exa
      xclip
      xsel
      maim
      thefuck
      unzip
      zoxide
      ripgrep
      ghq
      gh
      fzf
      cachix
      glib
      imagemagick
      scrot

      # encryption of dotfiles
      git-crypt
      gnupg

      # libs
      openssl
      pinentry_qt
      pkg-config
      gcc
      cmake

      # Fonts
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
      font-awesome
    ];
  };

  programs = {
    zsh = {
      enable = true;
      shellAliases = {
        l = "exa --icons";
        ll = "exa --icons -l";
        la = "exa --icons -l -a";
        update = "cd ~/dotfiles && ./update.sh && ./apply-system.sh && ./apply-users.sh && cd -";
      };
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "zoxide" "npm" "rust" "direnv" ];
        theme = "robbyrussell";
      };
      initExtra = ''
        unset THEME
        eval "$(atuin init zsh)"
        eval "$(thefuck --alias e)"
        eval "$(starship init zsh)"
      '';
      enableAutosuggestions = true;
      enableSyntaxHighlighting = true;
    };

    ncspot = {
      enable = true;
      package = pkgs.ncspot.overrideAttrs (o: {
        buildNoDefaultFeatures = false;
        buildFeatures = [ "cover" "mpris" "notify" "share_clipboard" "cursive/pancurses-backend" "with_pulseaudio" ];
      });
      settings = {
        shuffle = true;
        gapless = true;
        use_nerdfont = true;
        default_keybindings = true;
        notify = true;
        repeat = "playlist";
      };
    };


    direnv.enable = true;
    direnv.nix-direnv.enable = true;
    gpg.enable = true;
    git.enable = true;
    starship.enable = true;
    zellij.enable = true;

    # Let Home Manager install and manage itself.
    home-manager.enable = true;
  };

  services = {
    picom = {
      enable = true;
      activeOpacity = "0.80";
      inactiveOpacity = "0.80";
      blur = true;
      blurExclude = [
        "class_g = 'slop'"
        "class_g = 'awesome'"
        "class_g = 'Peek'"
        "name *= 'rect-overlay'"
      ];
      extraOptions = ''
        blur: {
          method = "dual_kawase";
          strength = 7;
          background = true;
          background-frame = false;
          background-fixed = false;
        }

        animations = false;
        animation-stiffness = 200.0;
        animation-dampening = 30.0;
        animation-clamping = false;
        animation-mass = 0.7;
        animation-for-open-window = "zoom";
        animation-for-menu-window = "slide-down";
        animation-for-transient-window = "slide-down";

        shadow = true;
        shadow-radius = 16;
        shadow-opacity = .7;
        shadow-offset-x = -4;
        shadow-offset-y = -4;

        use-ewmh-active-win = true;
        spawn-center-screen = true;
        unredir-if-possible = true; # for games
      '';
      experimentalBackends = true;

      backend = "glx";
      fadeDelta = 5;
      vSync = true;
      opacityRule = [
        "100:class_g   *?= 'Firefox'"
        "100:class_g   *?= 'Alacritty'"
        "100:class_g   *?= 'neovide'"
        "85:class_g   *?= 'discord'"
        "100:class_g *?= 'awesome'"
      ];
      package = pkgs.picom-dccsillag;
    };

    gpg-agent = {
      enable = true;
      pinentryFlavor = "qt";
    };

  };

  xresources.extraConfig = builtins.readFile (
    xresources + "/mocha.Xresources"
  );


  xdg.configFile = {
    nvim = {
      source = ./config/nvim;
      recursive = true;
    };
    awesome = {
      source = ./config/awesome;
      recursive = true;
    };
    alacritty = {
      source = ./config/alacritty;
      recursive = true;
    };
    rofi = {
      source = ./config/rofi;
      recursive = true;
    };
    zellij = {
      source = ./config/zellij;
      recursive = true;
    };
    cava = {
      source = ./config/cava;
      recursive = true;
    };
  };
}
