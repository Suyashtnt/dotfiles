{ config, pkgs, overlays, ... }:

{
  nix = {
    package = pkgs.nixFlakes;
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
      ];
      substituters = [
        "https://cache.nixos.org?priority=10"
        "https://fortuneteller2k.cachix.org"
      ];
    };
  };

  imports =
    [
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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
      sddm.enable = true;
      defaultSession = "none+awesome";
    };

    windowManager.awesome = {
      enable = true;
      package = (pkgs.awesome-git.override {
        lua = pkgs.luajit;
      });
      luaModules = with pkgs.luaPackages; [
        luarocks
        lgi
        vicious
      ];
    };

    layout = "za";
    xkbVariant = "";
    videoDrivers = [ "nvidia" ]; # remember to change this people
  };

  services.plex = {
    enable = true;
    openFirewall = true;
  };

  hardware.opengl.enable = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable; # also this

  services.usbmuxd.enable = true;
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.epson-escpr ];
  services.avahi.enable = true;
  services.avahi.nssmdns = true;

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

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tntman = {
    isNormalUser = true;
    description = "Tabiasgeee Human"; # Now my real name will not be leaked :)
    extraGroups = [ "networkmanager" "wheel" "scanner" "lp" ];
    packages = with pkgs; [ ];
    shell = pkgs.zsh;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = overlays;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim
    libimobiledevice
    ifuse
  ];
  environment.variables.FLAKE = "~/dotfiles";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether. NOTE TO SELF: ACTUALLY ENABLE FIREWALL
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
