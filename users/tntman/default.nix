{
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ../modules/git
    ../modules/gtk
    ../modules/hyprland
    ../modules/programs/btop
    ../modules/programs/cava
    ../modules/programs/dunst
    ../modules/programs/eww
    ../modules/programs/firefox
    ../modules/programs/foot
    ../modules/programs/neofetch
    ../modules/programs/obs
    ../modules/programs/spotify
    ../modules/programs/vscode
    ../modules/swaylock
    ../modules/tools/direnv.nix
    ../modules/tools/xdg.nix
    ../modules/zsh
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
      wofi
      authy
      dolphin

      # CLI utils
      xorg.xhost
      unzip
      ripgrep
      cachix
      docker-compose

      openssl
    ];
  };

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;
  };

  xresources.extraConfig = builtins.readFile (
    inputs.xresources + "/mocha.Xresources"
  );
}
