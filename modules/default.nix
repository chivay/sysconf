{ pkgs, ... }:
{
  imports = [
    ./nix.nix
    ./nonfree.nix
    ./sound.nix
    ./chromium.nix
  ];

  xdg.portal.wlr.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
}
