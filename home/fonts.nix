{ pkgs, ... }:
{
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    cascadia-code
    noto-fonts
    noto-fonts-emoji
  ];
}
