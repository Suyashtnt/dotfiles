{
  pkgs,
  hostname,
  ...
}: {
  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [443 80 22];
      allowedUDPPorts = [443 80];
    };

    hostName = hostname;
    networkmanager.enable = true;
  };
}
