{ lib, pkgs, overlays, xresources, config, discord-theme, hyprland, webcord, geticons, hyprpaper, hyprpicker, waybar-src, btop-theme, ... }:
{

  nixpkgs.overlays = overlays;

  home = {
    username = "tntman";
    homeDirectory = "/home/tntman";

    stateVersion = "22.05";

    packages = with pkgs; [
      # General
      firefox
      alacritty
      gitkraken
      rofi
      wofi
      neovim-nightly
      neovide
      virt-manager
      obsidian
      android-studio
      thunderbird
      swaylock-effects
      btop
      sptlrx
      helix # experimental
      nix-index

      # from flakes
      webcord.packages.${pkgs.system}.default
      hyprpaper.packages.${pkgs.system}.default
      #hyprpicker.packages.${pkgs.system}.default doesnt work on nvidia
      geticons
      (waybar.overrideAttrs (old: {
        src = waybar-src;
        mesonFlags = old.mesonFlags
          ++ [ "-Dexperimental=true" ];
        patchPhase = ''
          substituteInPlace src/modules/wlr/workspace_manager.cpp --replace "zext_workspace_handle_v1_activate(workspace_handle_);" "const std::string command = \"hyprctl dispatch workspace \" + name_; system(command.c_str());"
        '';
      }))

      # CLI utils
      atuin
      unzip
      exa
      thefuck
      unzip
      zoxide
      ripgrep
      ghq
      gh
      fzf
      cachix
      glib
      ueberzug
      docker-compose
      wl-clipboard
      grim
      slurp
      gitui
      cava
      spotify-tui
      pfetch
      neofetch

      # encryption of dotfiles
      git-crypt
      gnupg

      # libs
      openssl
      pinentry-qt
      pkg-config
      gcc
      cmake

      # Fonts
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
      font-awesome
      emacs-all-the-icons-fonts
    ];

    file.btop = {
      source = btop-theme;
      target = ".config/btop/themes";
    };
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

    swaylock = {
      settings = {
        clock = true;
        color = "2e3440";
        show-failed-attempts = true;
        indicator = true;
        indicator-radius = 200;
        indicator-thickness = 20;
        line-color = "2e3440";
        ring-color = "434c5e";
        inside-color = "3b4252";
        key-hl-color = "5e81ac";
        separator-color = "00000000";
        text-color = "d8dee9";
        text-caps-lock-color = "";
        line-ver-color = "2e3440";
        ring-ver-color = "81a1c1";
        inside-ver-color = "2e3440";
        text-ver-color = "d8dee9";
        ring-wrong-color = "bf616a";
        text-wrong-color = "cce9ea";
        inside-wrong-color = "3b4252";
        inside-clear-color = "3b4252";
        text-clear-color = "d8dee9";
        ring-clear-color = "a3be8c";
        bs-hl-color = "bf616a";
        line-uses-ring = false;
        grace = 2;
        grace-no-mouse = true;
        grace-no-touch = true;
        datestr = "%d.%m";
        fade-in = "0.1";
        ignore-empty-password = true;
      };
    };

    doom-emacs = {
      enable = true;
      doomPrivateDir = ./config/doom.d;
    };

    eww = {
      enable = true;
      package = pkgs.eww-wayland;
      configDir = ./config/eww;
    };

    ncspot = {
      enable = true;
      package = (pkgs.ncspot.override {
        withMPRIS = true;
        withPulseAudio = true;
      }).overrideAttrs (old: {
        buildFeatures = (old.buildFeatures or [ ]) ++ [ "cover" "share_clipboard" ];
        cargoBuildFeatures = (old.buildFeatures or [ ]) ++ [ "cover" "share_clipboard" ];

        buildInputs = (old.buildInputs or [ ]) ++ (with pkgs; [
          ueberzug
          xorg.libX11
        ]);

        nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ (with pkgs; [
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
    spotifyd = {
      enable = true;
      settings = builtins.fromTOML (builtins.readFile ./config/spotifyd.toml);
    };

    dunst = {
      enable = true;
      iconTheme = {
        name = "Adwaita";
        size = "32x32";
        package = pkgs.gnome.adwaita-icon-theme;
      };
      settings = {
        global = {
          frame_color = "#89B4FA";
          separator_color = "frame";
          corner_radius = 12;
        };

        urgency_low = {
          background = "#1E1E2E";
          foreground = "#CDD6F4";
        };

        urgency_normal = {
          background = "#1E1E2E";
          foreground = "#CDD6F4";
        };

        urgency_critical = {
          background = "#1E1E2E";
          foreground = "#CDD6F4";
          frame_color = "#FAB387";
        };
      };
    };

    swayidle = {
      enable = true;
      events = [
        {
          event = "before-sleep";
          command = "swaylock";
        }
        {
          event = "lock";
          command = "swaylock";
        }
      ];
      timeouts = [
        {
          timeout = 300;
          command = "hyprctl dispatch dpms off";
          resumeCommand = "hyprctl dispatch dpms on";
        }
        {
          timeout = 310;
          command = "loginctl lock-session";
        }
      ];
    };

    gpg-agent = {
      enable = true;
      pinentryFlavor = "qt";
    };

    emacs = {
      enable = true;
    };
  };

  home.pointerCursor.package = pkgs.nordzy-cursor-theme;
  home.pointerCursor.name = "Nordzy-cursors";
  home.pointerCursor.size = 16;
  home.pointerCursor.gtk.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    package = (hyprland.packages.x86_64-linux.hyprland.override {
      nvidiaPatches = true;
    });
  };


  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Dark";
      package = pkgs.catppuccin-gtk;
    };
  };
  qt = {
    enable = true;
    platformTheme = "gtk";
  };

  xresources.extraConfig = builtins.readFile (
    xresources + "/mocha.Xresources"
  );


  xdg.configFile = {
    nvim = {
      source = ./config/nvim;
      recursive = true;
    };
    neofetch = {
      source = ./config/neofetch;
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
    hypr = {
      source = ./config/hypr;
      recursive = true;
    };
    waybar = {
      source = ./config/waybar;
      recursive = true;
    };
    helix = {
      source = ./config/helix;
      recursive = true;
    };
  };
}
