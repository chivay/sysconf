{ nixpkgs, nixpkgs-stable, home-manager, nixos-hardware, ... }:
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
    ];
  };

  xakep = {
    system = "x86_64-linux";
    modulesExtra = [
      home-manager.nixosModules.home-manager
      hardware.common-cpu-intel
      hardware.common-pc-laptop-ssd
      hardware.lenovo-thinkpad-x250
    ];
  };

  raspi = {
    system = "aarch64-linux";
    modulesExtra = [ ];
  };

  gbur = {
    system = "aarch64-linux";
    modulesExtra = [];
  };
}
