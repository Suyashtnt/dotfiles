{pkgs, ...}: {
  programs.wezterm = {
    enable = true;
    package = pkgs.wezterm-git;
    extraConfig = builtins.readFile ./wezterm.lua;
  };
}
