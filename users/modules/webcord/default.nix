{
  inputs,
  pkgs,
  ...
}: {
  programs.webcord = {
    enable = true;
    package = inputs.webcord.packages.${pkgs.system}.default.override {
      flags = ["--add-css-theme=${inputs.discord}/themes/mocha.theme.css"];
    };
  };
}
