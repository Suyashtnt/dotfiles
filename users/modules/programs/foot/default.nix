{
  pkgs,
  lib,
  ...
}: let
  mkService = lib.recursiveUpdate {
    Unit.PartOf = ["graphical-session.target"];
    Unit.After = ["graphical-session.target"];
    Install.WantedBy = ["graphical-session.target"];
  };
in {
  home.packages = with pkgs; [
    foot
  ];

  xdg.configFile.foot = {
    source = ./config;
  };

  systemd.user.services.foot = mkService {
    Unit.Description = "Foot server";
    Service.ExecStart = "${pkgs.foot}/bin/foot --server";
  };
}
