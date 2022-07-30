{
  description = "Suyashtnt's (maybe) good dotfiles";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nh = {
      url = "github:viperML/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    nixpkgs-f2k.url = "github:fortuneteller2k/nixpkgs-f2k";

    flake-utils.url = "github:numtide/flake-utils";

    xresources.url = "github:catppuccin/xresources";
    xresources.flake = false;

    fnlfmt-git.url = "sourcehut:~technomancy/fnlfmt";
    fnlfmt-git.flake = false;
  };

  outputs = { self, nixpkgs, home-manager, neovim-nightly-overlay, nh, flake-utils, nixpkgs-f2k, xresources, fnlfmt-git, ... }:
    let
      system = "x86_64-linux";
      overlays = [
        neovim-nightly-overlay.overlay
        nixpkgs-f2k.overlays.default
      ];
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true; # for nvidia, gitkraken, discord, etc
        };
      };
      lib = nixpkgs.lib;
    in
    {
      homeConfigurations = {
        GAMER-PC = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};

          modules = [
            { _module.args = { inherit overlays nh xresources; }; }
            ./users/tntman/home.nix
          ];
        };
      };
      nixosConfigurations = {
        GAMER-PC = lib.nixosSystem {
          inherit system;

          modules = [
            { _module.args = { inherit overlays; }; }
            ./system/GAMER-PC/configuration.nix
          ];
        };
      };
      devShell.${system} = pkgs.mkShell {
        buildInputs = with pkgs; [
          rnix-lsp
          sumneko-lua-language-server
          stylua
          python311
          yaml-language-server
          fennel
          (fnlfmt.overrideAttrs (old: {
            version = "git";
            src = fnlfmt-git;
          }))
        ];
      };
    };
}
