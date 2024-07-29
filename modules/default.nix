{ pkgs, ... }:
{
  imports = [
    ./nix.nix
    ./nonfree.nix
    ./sound.nix
    ./chromium.nix
  ];

  xdg.portal.enable = true;
  xdg.portal.wlr.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-wlr ];
  xdg.portal.xdgOpenUsePortal = true;
}
