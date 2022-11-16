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
      nixopsUnstable
      wakatime

      # libs
      openssl
      pinentry-qt
      libsForQt5.qt5.qtwayland
      pkg-config
      gcc
      cmake
    ];
  };

  programs = {
    ncspot = {
      enable = true;
      package =
        (pkgs.ncspot.override {
          withMPRIS = true;
          withPulseAudio = true;
        })
        .overrideAttrs (old: {
          buildFeatures = (old.buildFeatures or []) ++ ["cover" "share_clipboard"];
          cargoBuildFeatures = (old.buildFeatures or []) ++ ["cover" "share_clipboard"];

          buildInputs =
            (old.buildInputs or [])
            ++ (with pkgs; [
              ueberzug
              xorg.libX11
            ]);

          nativeBuildInputs =
            (old.nativeBuildInputs or [])
            ++ (with pkgs; [
              python311
            ]);
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

    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
      ];
    };

    vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        vscodevim.vim
        yzhang.markdown-all-in-one
        bbenoist.nix
        WakaTime.vscode-wakatime
        catppuccin.catppuccin-vsc
        mkhl.direnv
        dbaeumer.vscode-eslint
        eamodio.gitlens
        svelte.svelte-vscode
        denoland.vscode-deno
        lokalise.i18n-ally
        vadimcn.vscode-lldb
      ];
    };

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
