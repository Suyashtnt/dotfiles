{inputs, ...}: {
  home.file.btop = {
    source = inputs.btop-theme;
    target = ".config/btop/themes";
  };

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "catppuccin_mocha";
      theme_background = false;
      vim_keys = true;
    };
  };
}
