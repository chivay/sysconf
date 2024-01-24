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

  environment.etc = {
    "pipewire/pipewire.conf.d/pipewire.conf".text = ''
       context.modules = [
        {   name = libpipewire-module-roc-sink
            args = {
                fec.code = rs8m
                remote.ip = 192.168.1.10
                remote.source.port = 10001
                remote.repair.port = 10002
                sink.name = "RP4 ROC"
                sink.props = {
                   node.name = "roc-sink"
                }
            }
        }
      ]
    '';
  };

  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;
  programs.wireshark.enable = true;
  programs.mosh.enable = true;

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
  hardware.rtl-sdr.enable = true;
  services.blueman.enable = true;
  services.usbmuxd.enable = true;
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [ gutenprint hplip ];
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;
  services.openssh.enable = true;
  services.tailscale.enable = true;

  services.resolved.enable = true;
  #services.mullvad-vpn.enable = true;

  environment.systemPackages = with pkgs; [
    git
    virt-manager
    wireguard-tools
    virtiofsd
    sbctl
    lm_sensors
  ];
  virtualisation.libvirtd = {
    enable = true;
  };
  virtualisation.spiceUSBRedirection.enable = true;
  virtualisation.docker.enable = true;
  documentation.dev.enable = true;

  nix.settings = {
    # we have 16 + 4 threads;
    # use up to 10 threads ~ half a CPU;
    max-jobs = 2;
    cores = 5;
  };

  system.stateVersion = "22.05";
}

