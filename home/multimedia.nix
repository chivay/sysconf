{ config, lib, pkgs, ... }:
{
  programs.ncspot = {
    enable = true;
    settings = {
      backend = "pulseaudio";
      theme = {
        background = "#191414";
        primary = "#FFFFFF";
        secondary = "light black";
        title = "#1DB954";
        playing = "#1DB954";
        playing_selected = "#1ED760";
        playing_bg = "#191414";
        highlight = "#FFFFFF";
        highlight_bg = "#484848";
        error = "#FFFFFF";
        error_bg = "red";
        statusbar = "#191414";
        statusbar_progress = "#1DB954";
        statusbar_bg = "#1DB954";
        cmdline = "#FFFFFF";
        cmdline_bg = "#191414";
        search_match = "light red";
      };
    };
  };

  home.packages = with pkgs; [
    imv
    spotify
    ncspot
    mpv
    pavucontrol
  ];
}
