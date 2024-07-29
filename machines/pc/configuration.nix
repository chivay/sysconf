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
  programs.wireshark.enable = true;
  programs.mosh.enable = true;
  programs.nix-ld.enable = true;

  networking.hostName = "nixos";

  boot.binfmt.emulatedSystems = [ "aarch64-linux" "armv7l-linux" ];
  boot.bootspec.enable = true;

  systemd.network = {
    enable = true;
    links = {
      "40-eth" = {
        matchConfig.MACAddress = "04:42:1a:eb:58:bd";
        linkConfig.WakeOnLan = "magic";
      };
    };
    networks = {
      "40-eth" = {
        matchConfig.Name = "eth0";
        DHCP = "yes";
        dhcpV4Config.UseDNS = true;
      };
    };
  };

  time.timeZone = "Europe/Warsaw";
  networking.useDHCP = false;
  #networking.nameservers = [ "1.1.1.1" "1.0.0.1" ];
  networking.wireless.iwd.enable = true;
  networking.useNetworkd = true;

  programs.sway.enable = true;
  hardware.graphics.enable = true;
  hardware.graphics.extraPackages = with pkgs; [
    vaapiIntel
    vaapiVdpau
    libvdpau-va-gl
    intel-media-driver
  ];
  hardware.bluetooth.enable = true;
  hardware.rtl-sdr.enable = true;
  services.blueman.enable = true;
  services.usbmuxd.enable = true;
  services.printing.enable = true;
  #services.printing.drivers = with pkgs; [ gutenprint hplip ];
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;
  services.openssh.enable = true;
  services.tailscale.enable = true;
  services.flatpak.enable = true;

  services.resolved.enable = true;
  #services.mullvad-vpn.enable = true;

  environment.systemPackages = with pkgs; [
    git
    virt-manager
    wireguard-tools
    virtiofsd
    sbctl
    lm_sensors
    zellij
  ];
  virtualisation.libvirtd = {
    enable = true;
  };
  virtualisation.spiceUSBRedirection.enable = true;
  virtualisation.docker.enable = true;
  documentation.dev.enable = true;

  services.pcscd.enable = true;

  nix.settings = {
    # we have 16 + 4 threads;
    # use up to 10 threads ~ half a CPU;
    max-jobs = 2;
    cores = 5;
  };

  system.stateVersion = "22.05";
}

