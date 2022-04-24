{ config, pkgs, lib, modulesPath, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./p4net.nix
      ../../modules
      ../../modules/intel-vaapi.nix
      ../../home
    ];

  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;
  programs.wireshark.enable = true;

  networking.hostName = "nixos";

  systemd.network = {
    enable = true;
    networks = {
      "40-wlan0" = {
        matchConfig.Name = "wlan0";
        DHCP = "yes";
        dhcpV4Config.UseDNS = false;
      };
    };
  };

  time.timeZone = "Europe/Warsaw";
  networking.useDHCP = false;
  networking.nameservers = [ "1.1.1.1" "1.0.0.1" ];
  networking.wireless.iwd.enable = true;
  networking.useNetworkd = true;

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
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [ gutenprint hplip ];
  services.avahi.enable = true;
  services.avahi.nssmdns = true;

  services.resolved.enable = true;

  environment.systemPackages = with pkgs; [ git virt-manager wireguard-tools ];
  virtualisation.libvirtd = {
    enable = true;
  };
  virtualisation.docker.enable = true;

  system.stateVersion = "22.05";
}

