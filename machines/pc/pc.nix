{ config, pkgs, lib, modulesPath, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules
      ../../modules/intel-vaapi.nix
      ../../home
    ];

  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;

  networking.hostName = "nixos";

  time.timeZone = "Europe/Warsaw";
  networking.useDHCP = false;
  networking.interfaces.enp5s0.useDHCP = false;
  networking.interfaces.wlan0.useDHCP = true;
  networking.wireless.iwd.enable = true;

  networking.wireguard = {
    enable = true;
    interfaces = {
      p4net = {
        ips = [ "198.18.2.4/16" ];
        privateKeyFile = "/persist/p4net/privkey";
        peers = [
          {
            publicKey = "n95378M/NgKYPLl2vpxYA32tLt8JJ3u3BsNP0ykSiS8=";
            allowedIPs = [ "198.18.0.0/16" ];
            endpoint = "gbur.potega.xyz:51821";
          }
        ];
      };
    };
  };

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
  virtualisation.docker.enable = true;

  system.stateVersion = "22.05";
}

