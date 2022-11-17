{
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ../modules/dunst
    ../modules/eww
    ../modules/firefox
    ../modules/gtk
    ../modules/hyprland
    ../modules/spotify
    ../modules/swaylock
    ../modules/tools/btop.nix
    ../modules/tools/direnv.nix
    ../modules/tools/xdg.nix
    ../modules/webcord
    ../modules/zsh
    ../modules/vscode
    ../modules/obs
    inputs.hyprland.homeManagerModules.default
    inputs.webcord.homeManagerModules.default
  ];
  manual.manpages.enable = false;

  home = {
    username = "tntman";
    homeDirectory = "/home/tntman";

    stateVersion = "22.05";

    packages = with pkgs; [
      chromium #for js debugging and lighthoouse
      foot
      wofi
      helix
      authy
      dolphin
      easyeffects

      # CLI utils
      xorg.xhost
      unzip
      ripgrep
      ghq
      gh
      fzf
      cachix
      glib
      docker-compose
      gitui
      cava
      neofetch
      alsa-utils

      # libs
      openssl
      pinentry-qt
      pkg-config
      gcc
      cmake
    ];
  };

  programs = {
    gpg.enable = true;
    zellij.enable = true;

    # Let Home Manager install and manage itself.
    home-manager.enable = true;
  };

  services = {
    gpg-agent = {
      enable = true;
      pinentryFlavor = "qt";
    };
  };

  xresources.extraConfig = builtins.readFile (
    inputs.xresources + "/mocha.Xresources"
  );

  xdg.configFile = {
    neofetch = {
      source = ./config/neofetch;
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
    helix = {
      source = ./config/helix;
      recursive = true;
    };
    foot = {
      source = ./config/foot;
      recursive = true;
    };
  };
}
