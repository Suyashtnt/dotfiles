{ config, pkgs, lib, ... }:
{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "discord"
    "gitkraken"
    "unityhub"
  ];

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
      firefox
      alacritty
      atuin
      exa
      xclip
      maim
      discord
      gitkraken
      thefuck
      git-crypt
      gnupg
      openssl
      pinentry_qt
      pkg-config
      unzip
      rofi
      stylua
      ncspot
      zoxide
      ripgrep
      neovim-nightly
      neovide
      gcc
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
        update = "sudo nixos-rebuild switch";
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
      blur = true;
      blurExclude = [
        "class_g = 'slop'"
      ];
      extraOptions = ''
        corner-radius = 15;
        blur-method = "dual_kawase";
        blur-strength = "10";
        xinerama-shadow-crop = true;
      '';
      experimentalBackends = true;

      shadowExclude = [
        "bounding_shaped && !rounded_corners"
      ];

      fade = true;
      fadeDelta = 5;
      vSync = true;
      opacityRule = [
        "100:class_g   *?= 'Chromium-browser'"
        "100:class_g   *?= 'Firefox'"
      ];
      package = pkgs.picom.overrideAttrs (o: {
        src = pkgs.fetchFromGitHub {
          repo = "picom";
          owner = "ibhagwan";
          rev = "44b4970f70d6b23759a61a2b94d9bfb4351b41b1";
          sha256 = "0iff4bwpc00xbjad0m000midslgx12aihs33mdvfckr75r114ylh";
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
  };
}
