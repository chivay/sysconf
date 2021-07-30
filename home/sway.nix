{ config, lib, pkgs, ... }:
{
  wayland.windowManager.sway = {
    enable = true;
    config = {
      modifier = "Mod4";
      terminal = "alacritty";
      input = { "type:keyboard" = { xkb_layout = "pl"; }; };
      keybindings =
        let
          modifier = config.wayland.windowManager.sway.config.modifier;
        in
        lib.mkOptionDefault {
          # Screenshot helper
          Print = "exec ${pkgs.sway-contrib.grimshot}/bin/grimshot copy area";

          # Add support for 10th workspace
          "${modifier}+0" = "workspace number 10";
          "${modifier}+Shift+0" = "move container to workspace number 10";
        };

    };
  };

  programs.mako = {
    enable = true;
    defaultTimeout = 2000;
  };

  gtk = {
    enable = true;
    iconTheme.package = pkgs.gnome_themes_standard;
    iconTheme.name = "Adwaita";
  };

  services.gammastep = {
    enable = true;
    provider = "manual";
    latitude = "52.23020816947126";
    longitude = "21.011293104313307";
  };

  home.packages = with pkgs; [
    alacritty
    wdisplays
  ];
}
