{ config, pkgs, lib, modulesPath, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules
      ../../home
    ];

  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;

  networking.hostName = "nixos";

  time.timeZone = "Europe/Warsaw";
  networking.useDHCP = false;
  networking.interfaces.enp5s0.useDHCP = true;
  networking.interfaces.wlan0.useDHCP = true;
  networking.wireless.iwd.enable = true;

  programs.sway.enable = true;
  hardware.opengl.enable = true;
  hardware.opengl.extraPackages = with pkgs; [
    vaapiIntel
    vaapiVdpau
    libvdpau-va-gl
    intel-media-driver
  ];
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  services.usbmuxd.enable = true;

  environment.systemPackages = with pkgs; [ virt-manager ];
  virtualisation.libvirtd = {
    enable = true;
  };

  system.stateVersion = "22.05";
}

