{pkgs, ...}: {
  users.users.tntman = {
    isNormalUser = true;
    description = "Tabiasgeee Human";
    extraGroups = ["networkmanager" "wheel" "scanner" "lp" "docker"];
    initialPassword = "password"; # Change this with passwd
    packages = with pkgs; [];
    shell = pkgs.zsh;
  };

  networking.hostName = "GAMER-PC";
  time.timeZone = "Africa/Johannesburg";
  i18n.defaultLocale = "en_ZA.UTF-8";

  programs.xwayland.enable = true;

  services = {
    xserver = {
      layout = "za";
      xkbVariant = "";
    };

    greetd = {
      enable = true;
      settings = rec {
        initial_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
          user = "tntman";
        };
        default_session = initial_session;
      };
    };

    plex = {
      enable = true;
      openFirewall = true;
    };

    gnome = {
      glib-networking.enable = true;
      gnome-keyring.enable = true;
    };

    udev.packages = with pkgs; [
      gnome.gnome-settings-daemon
    ];

    usbmuxd.enable = true;
    avahi.enable = true;
    avahi.nssmdns = true;
    flatpak.enable = true;
    openssh.enable = true;
  };

  systemd.services.greetd = {
    unitConfig = {
      ExecStartPre = "kill -SIGRTMIN+21 1";
      ExecStartPost = "kill -SIGRTMIN+20 1";
    };
  };

  security = {
    # allow wayland lockers to unlock the screen
    pam.services.swaylock.text = "auth include login";
  };

  programs.zsh.enable = true;
  programs.dconf.enable = true;

  virtualisation = {
    docker.enable = true;
  };

  environment.systemPackages = with pkgs; [
    vim
    libimobiledevice
    gnome.adwaita-icon-theme
    ifuse
    virt-manager
    docker-client
    pkgs.greetd.tuigreet
  ];

  environment.variables = {
    FLAKE = "~/dotfiles";
  };
}
