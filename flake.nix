{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-21.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs, nixpkgs-stable, home-manager, nixos-hardware, flake-utils }@inputs:
    flake-utils.lib.eachDefaultSystem
      (system:
      let
        pkgs = import nixpkgs { inherit system; };
        inherit (pkgs) lib;
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = (with pkgs; [
            nixpkgs-fmt
          ]);
        };
      }) // {
      nixosConfigurations = nixpkgs.lib.mapAttrs
        (hostname: { system, modulesExtra, ... }: nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./machines/${hostname}/${hostname}.nix
          ] ++ modulesExtra;
        })
        (import ./machines inputs);
    };
}
