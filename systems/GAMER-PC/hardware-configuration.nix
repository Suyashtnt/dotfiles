# note to people who want to steal (which is fine): edit this to your needs
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  boot.resumeDevice = "/dev/disk/by-label/root";

  fileSystems."/" = {
    device = "/dev/disk/by-label/root";
    fsType = "btrfs";
    options = ["subvol=root compress=zstd"];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-label/root";
    fsType = "btrfs";
    options = ["subvol=nix compress=zstd noatime"];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-label/root";
    fsType = "btrfs";
    options = ["subvol=home compress=zstd"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/BOOT";
    fsType = "vfat";
  };

  fileSystems."/mnt/BulkStorage" = {
    device = "/dev/disk/by-label/BulkStorage";
    fsType = "ext4";
  };

  fileSystems."/mnt/Games" = {
    device = "/dev/disk/by-label/Games";
    fsType = "ntfs";
    options = ["rw" "uid=1000"];
  };

  fileSystems."/swap" = {
    device = "/dev/disk/by-label/root";
    fsType = "btrfs";
    options = ["subvol=swap noatime"];
  };

  swapDevices = [{device = "/swap/swapfile";}];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
