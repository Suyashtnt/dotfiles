{
  nixpkgs,
  self,
  ...
}: let
  inputs = self.inputs;
  bootloader = ../modules/core/bootloader.nix;
  core = ../modules/core;
  intel = ../modules/intel;
  nvidia = ../modules/nvidia;
  wayland = ../modules/wayland;
  printing = ../modules/printing;
  hmModule = inputs.home-manager.nixosModules.home-manager;
in {
  GAMER-PC = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {
      inherit inputs;
      hostname = "GAMER-PC";
    };
    modules = [
      ./GAMER-PC/configuration.nix
      ./GAMER-PC/hardware-configuration.nix
      bootloader
      core
      intel
      printing
      nvidia
      wayland
      hmModule
      {
        home-manager = {
          useUserPackages = true;
          useGlobalPkgs = true;
          extraSpecialArgs = {
            inherit inputs;
            inherit self;
          };
          users.tntman = ../users/tntman;
        };
      }
    ];
  };
}
