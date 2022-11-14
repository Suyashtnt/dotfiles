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

    fnlfmt-git = {
      url = "sourcehut:~technomancy/fnlfmt";
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

  outputs = { self, nixpkgs, home-manager, flake-utils, nixpkgs-f2k, xresources
    , fnlfmt-git, grub-theme, hyprland, nixpkgs-wayland, crane, btop-theme
    , swww-src, ... }:
    let
      system = "x86_64-linux";
      overlays = [ nixpkgs-f2k.overlays.default nixpkgs-wayland.overlay ];
      pkgs = import nixpkgs {
        inherit system overlays;
        config = {
          allowUnfree = true; # for nvidia, gitkraken, discord, etc
        };
      };
      lib = nixpkgs.lib;

      craneLib = crane.lib.${system};

      swww = craneLib.buildPackage {
        src = craneLib.cleanCargoSource swww-src;

        nativeBuildInputs = with pkgs; [ pkg-config libxkbcommon ];

        doCheck = false; # breaks on nixOS
      };
    in {
      nixosConfigurations = {
        GAMER-PC = lib.nixosSystem {
          inherit system;

          modules = [
            { _module.args = { inherit overlays grub-theme; }; }
            ./system/GAMER-PC/configuration.nix
            home-manager.nixosModules.home-manager
            # HM config configurer
            ({
              home-manager.useGlobalPkgs = true;
              home-manager.sharedModules =
                [ hyprland.homeManagerModules.default ];
              home-manager.users.tntman = lib.mkMerge [
                {
                  _module.args = {
                    inherit overlays xresources pkgs lib hyprland btop-theme
                      swww;
                  };
                }
                ./users/tntman/home.nix
              ];
            })
          ];
        };
      };
      devShell.${system} = pkgs.mkShell {
        packages = with pkgs; [
          rnix-lsp
          rustc
          cargo
          sumneko-lua-language-server
          stylua
          python311
          yaml-language-server
          fennel
          nixfmt
          (fnlfmt.overrideAttrs (old: {
            version = "git";
            src = fnlfmt-git;
          }))
        ];
      };
    };
}
