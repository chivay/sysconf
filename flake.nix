{
  inputs = {
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-util = {
      url = "github:numtide/flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs, home-manager, nixos-hardware, flake-utils, agenix, lanzaboote, ... }@inputs:
    flake-utils.lib.eachDefaultSystem
      (system:
      let
        pkgs = import nixpkgs { inherit system; };
        inherit (pkgs) lib;
      in
      {
        formatter = pkgs.nixpkgs-fmt;
        devShells.default = pkgs.mkShell {
          buildInputs = (with pkgs; [
            nixpkgs-fmt
          ]);
        };
        checks = {
          format = pkgs.runCommand "check-format"
            {
              buildInputs = [ pkgs.nixpkgs-fmt ];
            }
            ''
              ${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt --check ${./.}
              touch $out
            '';
        };
      }) // {
      nixosConfigurations = nixpkgs.lib.mapAttrs
        (hostname: { system, modulesExtra, ... }: nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ({
              nix.nixPath = [
                "nixpkgs=${nixpkgs}"
              ];
            })
            ({
              nix.registry.nixpkgs.flake = nixpkgs;
              nix.registry.zig.to = {
                owner = "mitchellh";
                repo = "zig-overlay";
                type = "github";
              };

            })
            agenix.nixosModules.age
            ./machines/${hostname}/${hostname}.nix
          ] ++ modulesExtra;
        })
        (import ./machines inputs);
    };
}
