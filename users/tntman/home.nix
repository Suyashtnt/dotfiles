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
      ghq
      gh

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
      ];
      extraOptions = ''
        corner-radius = 18;
        transition-length = 600;

        blur: {
          method = "dual_kawase";
          strength = 9;
          background = true;
          background-frame = false;
          background-fixed = false;
        }

        animations = true;
        animation-stiffness = 100
        animation-window-mass = 0.4
        animation-dampening = 15
        animation-clamping = false

        animation-for-open-window = "zoom";
        animation-for-unmap-window = "zoom";
        animation-for-transient-window = "slide-up";

        animation-for-workspace-switch-in = "slide-down";
        animation-for-workspace-switch-out = "zoom";

        use-ewmh-active-win = true;

        spawn-center-screen = true;

        unredir-if-possible = true; # for games
      '';
      experimentalBackends = true;

      backend = "glx";
      fadeDelta = 5;
      vSync = true;
      opacityRule = [
        "100:class_g   *?= 'Chromium-browser'"
        "100:class_g   *?= 'Firefox'"
        "100:class_g   *?= 'Alacritty'"
        "100:class_g   *?= 'Neovide'"
        "85:class_g   *?= 'discord'"
      ];
      package = pkgs.picom.overrideAttrs (o: {
        src = pkgs.fetchFromGitHub {
          repo = "picom";
          owner = "dccsillag";
          rev = "51b21355696add83f39ccdb8dd82ff5009ba0ae5";
          sha256 = "crCwRJd859DCIC0pEerpDqdX2j8ZrNAzVaSSB3mTPN8=";
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
