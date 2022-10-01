{ config, pkgs, overlays, grub-theme, ... }:
let
  configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk";
    executable = true;
    text =
      let
        schema = pkgs.gsettings-desktop-schemas;
        datadir = "${schema}/share/gesettings/schemas/${schema.name}";
      in
      ''
        export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
        gnome_schema=org.gnome.desktop.interface
        gsettings set $gnome_schema gtk-theme 'Adwaita'
      '';
  };
in
{
  nix = {
    package = pkgs.nixStable;
    gc = {
      automatic = true;
      dates = "weekly";
    };
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    settings = {
      trusted-users = [ "root" "tntman" ];
      auto-optimise-store = true;
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "fortuneteller2k.cachix.org-1:kXXNkMV5yheEQwT0I4XYh1MaCSz+qg72k8XAi2PthJI="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "webcord.cachix.org-1:l555jqOZGHd2C9+vS8ccdh8FhqnGe8L78QrHNn+EFEs="
      ];
      substituters = [
        "https://cache.nixos.org?priority=10"
        "https://fortuneteller2k.cachix.org"
        "https://hyprland.cachix.org"
        "https://webcord.cachix.org"
      ];
    };
  };

  imports =
    [
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.theme = grub-theme + "/src/catppuccin-mocha-grub-theme";

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

  boot.extraModprobeConfig = "options kvm_intel nested=1";
  boot.supportedFilesystems = [ "ntfs" ];
  boot.kernelModules = [ "kvm-amd" ];

  networking.hostName = "GAMER-PC"; # Define your hostname. Remember to change this
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant. Remeber to enable this if you are using wifi

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone. Remember to change this
  time.timeZone = "Africa/Johannesburg";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_ZA.UTF-8";

  # Configure keymap in X11
  services.xserver = {
    enable = true;

    displayManager = {
      gdm.enable = true;
      gdm.wayland = true;
    };

    layout = "za";
    xkbVariant = "";
    videoDrivers = [ "nvidia" ]; # remember to change this people
  };


  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [ 
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
      font-awesome
      emacs-all-the-icons-fonts
    ];

    fontconfig = {
      defaultFonts = {
        monospace = [ "JetBrainsMono Nerd Font Mono" ];
      };
    };
  };

  programs.xwayland.enable = true;
  services.plex = {
    enable = true;
    openFirewall = true;
  };

  hardware.opengl.enable = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable; # also this if you don't got an nvidia card
  hardware.nvidia.modesetting.enable = true;

  services.usbmuxd.enable = true;
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.epson-escpr ];
  services.avahi.enable = true;
  services.avahi.nssmdns = true;
  services.gnome = {
    glib-networking.enable = true;
    gnome-keyring.enable = true;
  };

  hardware.sane.enable = true;
  hardware.sane.extraBackends = [ pkgs.sane-airscan ];


  sound.enable = false; # Pipewire doesn't like this on

  # rtkit is optional but recommended
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    config.pipewire = {
      "context.properties" = {
        "link.max-buffers" = 16;
        "log.level" = 2;
        "default.clock.rate" = 48000;
        "default.clock.quantum" = 32;
        "default.clock.min-quantum" = 32;
        "default.clock.max-quantum" = 32;
        "core.daemon" = true;
        "core.name" = "pipewire-0";
      };
      "context.modules" = [
        {
          name = "libpipewire-module-rtkit";
          args = {
            "nice.level" = -15;
            "rt.prio" = 88;
            "rt.time.soft" = 200000;
            "rt.time.hard" = 200000;
          };
          flags = [ "ifexists" "nofail" ];
        }
        { name = "libpipewire-module-protocol-native"; }
        { name = "libpipewire-module-profiler"; }
        { name = "libpipewire-module-metadata"; }
        { name = "libpipewire-module-spa-device-factory"; }
        { name = "libpipewire-module-spa-node-factory"; }
        { name = "libpipewire-module-client-node"; }
        { name = "libpipewire-module-client-device"; }
        {
          name = "libpipewire-module-portal";
          flags = [ "ifexists" "nofail" ];
        }
        {
          name = "libpipewire-module-access";
          args = { };
        }
        { name = "libpipewire-module-adapter"; }
        { name = "libpipewire-module-link-factory"; }
        { name = "libpipewire-module-session-manager"; }
      ];
    };

    config.pipewire-pulse = {
      "context.properties" = {
        "log.level" = 2;
      };
      "context.modules" = [
        {
          name = "libpipewire-module-rtkit";
          args = {
            "nice.level" = -15;
            "rt.prio" = 88;
            "rt.time.soft" = 200000;
            "rt.time.hard" = 200000;
          };
          flags = [ "ifexists" "nofail" ];
        }
        { name = "libpipewire-module-protocol-native"; }
        { name = "libpipewire-module-client-node"; }
        { name = "libpipewire-module-adapter"; }
        { name = "libpipewire-module-metadata"; }
        {
          name = "libpipewire-module-protocol-pulse";
          args = {
            "pulse.min.req" = "32/48000";
            "pulse.default.req" = "32/48000";
            "pulse.max.req" = "32/48000";
            "pulse.min.quantum" = "32/48000";
            "pulse.max.quantum" = "32/48000";
            "server.address" = [ "unix:native" ];
          };
        }
      ];
      "stream.properties" = {
        "node.latency" = "32/48000";
        "resample.quality" = 1;
      };
    };

    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  programs.zsh.enable = true;
  programs.dconf.enable = true;
  programs.adb.enable = true;

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        ovmf.enable = true;
        ovmf.packages = [ pkgs.OVMFFull.fd ];
        swtpm.enable = true;
      };
    };
    docker.enable = true;
    waydroid.enable = true;
    lxd.enable = true;  
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tntman = {
    isNormalUser = true;
    description = "Tabiasgeee Human"; # Now my real name will not be leaked :)
    extraGroups = [ "networkmanager" "wheel" "scanner" "lp" "libvirtd" "docker" "podman" "adbusers" ];
    packages = with pkgs; [ ];
    shell = pkgs.zsh;
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = overlays;


  environment.systemPackages = with pkgs; [
    neovim
    xdg-desktop-portal-wlr
    libimobiledevice
    gnome.adwaita-icon-theme
    ifuse
    virt-manager
    docker-client
    configure-gtk
  ];

  environment.variables = {
    FLAKE = "~/dotfiles";
    NIXOS_OZONE_WL = "1";
    GTK_USE_PORTAL = "0";
    __GL_GSYNC_ALLOWED = "0";
    __GL_VRR_ALLOWED = "0";
    DISABLE_QT5_COMPAT = "0";
    ANKI_WAYLAND = "1";
    DIRENV_LOG_FORMAT = "";
    WLR_DRM_NO_ATOMIC = "1";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    QT_QPA_PLATFORMTHEME = "qt5ct";
    GDK_BACKEND = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
    WLR_BACKEND = "vulkan";
    WLR_NO_HARDWARE_CURSORS = "1";
    XDG_SESSION_TYPE = "wayland";
    CLUTTER_BACKEND = "wayland";
  };

  environment.loginShellInit =
    ''
      dbus-update-activation-environment --systemd DISPLAY
      eval $(ssh-agent)
      eval $(gnome-keyring-daemon --start)
      export GPG_TTY=$TTY
    '';

  services.openssh.enable = true;
  services.udev.packages = with pkgs; [
    gnome.gnome-settings-daemon
  ];


  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment? If not, TLDR don't change this
}
