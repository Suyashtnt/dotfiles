{pkgs, ...}: {
  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [
      (nerdfonts.override {fonts = ["JetBrainsMono"];})
      font-awesome
      emacs-all-the-icons-fonts
      inter
    ];

    fontconfig = {
      defaultFonts = {
        monospace = ["ComicCodeLigatures Nerd Font"]; # or "JetBrainsMono Nerd Font" if you don't have ComicCodeLigatures
      };
    };
  };
}
