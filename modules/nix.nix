{ pkgs, ... }:
{
  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    settings = {
      trusted-substituters = [ "https://zig-nightly.cachix.org" ];
      trusted-public-keys = [
        "zig-nightly.cachix.org-1:OnBNrwrXNoCtCzjuMEfruWSaZEixGGSvFhc9OBtx1wg="
      ];
      auto-optimise-store = true;
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };
}
