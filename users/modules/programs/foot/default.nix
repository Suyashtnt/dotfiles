{pkgs, ...}: {
  home.packages = with pkgs; [
    foot
  ];

  xdg.configFile.foot = {
    source = ./config;
  };
}
