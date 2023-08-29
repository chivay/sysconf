{ pkgs, specialArgs, ... }:
{
  nix = {
    package = pkgs.nixVersions.stable;
    nixPath = [
      "nixpkgs=${specialArgs.inputs.nixpkgs}"
    ];

    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    settings = {
      auto-optimise-store = true;
    };

    registry.nixpkgs.flake = specialArgs.inputs.nixpkgs;
    registry.zig.to = {
      owner = "mitchellh";
      repo = "zig-overlay";
      type = "github";
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };
}
