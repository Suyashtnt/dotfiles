{
  description = "Suyashtnt's (maybe) good dotfiles";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    nixpkgs-wayland.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs-f2k.url = "github:fortuneteller2k/nixpkgs-f2k";

    crane = {
      url = "github:ipetkov/crane";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";

    xresources = {
      url = "github:catppuccin/xresources";
      flake = false;
    };

    btop-theme = {
      url = "github:catppuccin/btop";
      flake = false;
    };

    grub-theme = {
      url = "github:catppuccin/grub";
      flake = false;
    };

    swww-src = {
      url = "github:Horus645/swww";
      flake = false;
    };
  };

  outputs = {self, ...} @ inputs: let
    system = "x86_64-linux";

    pkgs = import inputs.nixpkgs {
      inherit system;
    };
  in {
    nixosConfigurations = import ./systems inputs;
    devShell.x86_64-linux = pkgs.mkShell {
      packages = with pkgs; [
        rnix-lsp
        yaml-language-server
        alejandra
      ];
    };
  };
}
