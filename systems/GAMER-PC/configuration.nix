{pkgs, ...}: {
  users.users.tntman = {
    isNormalUser = true;
    description = "Tabiasgeee Human";
    extraGroups = ["networkmanager" "wheel" "scanner" "lp" "libvirtd" "docker" "podman"];
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

  security = {
    # allow wayland lockers to unlock the screen
    pam.services.swaylock.text = "auth include login";
  };

  programs.zsh.enable = true;
  programs.dconf.enable = true;

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        ovmf.enable = true;
        ovmf.packages = [pkgs.OVMFFull.fd];
        swtpm.enable = true;
      };
    };
    docker.enable = true;
    lxd.enable = true;
  };

  environment.systemPackages = with pkgs; [
    vim
    libimobiledevice
    gnome.adwaita-icon-theme
    ifuse
    virt-manager
    docker-client
  ];

  environment.variables = {
    FLAKE = "~/dotfiles";
  };
}
