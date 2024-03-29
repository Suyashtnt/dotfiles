{pkgs, ...}: {
  home.packages = with pkgs; [
    thefuck
    atuin
  ];

  programs.zsh = {
    enable = true;
    shellAliases = {
      l = "exa --icons";
      ll = "exa --icons -l";
      la = "exa --icons -l -a";
      update = "~/dotfiles/update.sh";
    };
    oh-my-zsh = {
      enable = true;
      plugins = ["git" "zoxide" "npm" "rust" "direnv"];
      theme = "robbyrussell";
    };
    initExtra = ''
      unset THEME
      eval "$(atuin init zsh)"
      eval "$(thefuck --alias e)"
    '';
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
  };

  programs = {
    starship = {
      enable = true;
      settings = builtins.fromTOML (builtins.readFile ./starship.toml);
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    dircolors = {
      enable = true;
      enableZshIntegration = true;
    };

    exa.enable = true;
  };
}
