{ pkgs, ... }:
{
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    binaryCaches = [ "https://zig-nightly.cachix.org" ];
    binaryCachePublicKeys = [
      "zig-nightly.cachix.org-1:OnBNrwrXNoCtCzjuMEfruWSaZEixGGSvFhc9OBtx1wg="
    ];

    autoOptimiseStore = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };
}
