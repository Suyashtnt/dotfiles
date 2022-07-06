{ lib
, pkgs
, overlays
, nh
, ...
}:

{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "discord"
    "gitkraken"
    "unityhub"
  ];
  nixpkgs.overlays = overlays;

  home = {
    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    username = "tntman";
    homeDirectory = "/home/tntman";

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
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

      # encryption of dotfiles
      git-crypt
      gnupg

      # libs
      openssl
      pinentry_qt
      pkg-config
      gcc

      # Fonts
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
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
      activeOpacity = "0.90";
      inactiveOpacity = "0.90";
      blur = true;
      blurExclude = [
        "class_g = 'slop'"
      ];
      extraOptions = ''
        corner-radius = 18;
        transition-length = 600;

        blur-method = "dual_kawase";
        blur-kernel = "11x11gaussian";
        blur-strength = "24";
        blur-size = "36";
        blur-deviation = 4.0;

        xinerama-shadow-crop = true;
        spawn-center-screen = true;
      '';
      experimentalBackends = true;

      shadowExclude = [
        "bounding_shaped && !rounded_corners"
      ];

      fade = true;
      backend = "glx";
      fadeDelta = 5;
      vSync = true;
      opacityRule = [
        "100:class_g   *?= 'Chromium-browser'"
        "100:class_g   *?= 'Firefox'"
      ];
      package = pkgs.picom.overrideAttrs (o: {
        src = pkgs.fetchFromGitHub {
          repo = "picom";
          owner = "jonaburg";
          rev = "e3c19cd7d1108d114552267f302548c113278d45";
          sha256 = "4voCAYd0fzJHQjJo4x3RoWz5l3JJbRvgIXn1Kg6nz6Y=";
        };
      });
    };

    gpg-agent = {
      enable = true;
      pinentryFlavor = "qt";
    };
  };

  xresources.extraConfig = builtins.readFile (
    pkgs.fetchFromGitHub
      {
        owner = "catppuccin";
        repo = "xresources";
        rev = "86843e1452f247b1440fc04a883ed920378e4c6b";
        sha256 = "8tOtRWUBRSwzRX5VA5oPKT5GJgP9g/L3vsD0naPdam8=";
      } + "/Xresources"
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
  };
}
