{ nixpkgs, home-manager, nixos-hardware, lanzaboote, ... }:
let
  hardware = nixos-hardware.nixosModules;
in
{
  pc = {
    system = "x86_64-linux";
    modulesExtra = [
      home-manager.nixosModules.home-manager
      hardware.common-cpu-intel
      hardware.common-pc-ssd
      lanzaboote.nixosModules.lanzaboote
    ];
  };

  raspi = {
    system = "aarch64-linux";
    modulesExtra = [ ];
  };

  gbur = {
    system = "aarch64-linux";
    modulesExtra = [ ];
  };
}
