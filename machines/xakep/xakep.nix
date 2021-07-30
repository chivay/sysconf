{ config, pkgs, ... }:
let
  fetchGitHubKeys = { username, hash }:
    let
      data = builtins.fetchurl {
        url = "https://github.com/${username}.keys";
        sha256 = hash;
      };
    in
    pkgs.lib.splitString "\n" (builtins.readFile data);
  myKeys = fetchGitHubKeys {
    username = "chivay";
    hash = "13cs4ial80swh4q7jqcsgmlbvyy00glgwssarr7rdp0226rqc9lw";
  };
in
{
  imports = [
    ./hardware-configuration.nix
    ../../modules
    ../../home
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.supportedFilesystems = [ "btrfs" ];
  boot.initrd.network.ssh.enable = true;
  boot.initrd.network.ssh.authorizedKeys = myKeys;

  hardware.enableAllFirmware = true;
  hardware.opengl.enable = true;
  hardware.bluetooth.enable = true;
  hardware.ledger.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.devices = [ "nodev" ];
  boot.loader.grub.efiSupport = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

  networking.hostName = "xakep";
  networking.wireless.iwd.enable = true;

  networking.wireguard.interfaces = {
    wg-p4net = {
      ips = [ "198.18.2.2/16" ];
      listenPort = 51820;
      privateKeyFile = "/home/chivay/sys/wg-keys/private";
      peers = [
        {
          publicKey = "n95378M/NgKYPLl2vpxYA32tLt8JJ3u3BsNP0ykSiS8=";
          allowedIPs = [ "198.18.0.0/16" ];
          endpoint = "gbur.potega.xyz:51821";
          persistentKeepalive = 30;
        }
      ];
    };
  };

  # Set your time zone.
  time.timeZone = "Europe/Warsaw";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.useNetworkd = true;

  systemd.network.networks = {
    "wireless" = {
      matchConfig.Name = "wlan0";
      networkConfig.DHCP = "yes";
      networkConfig.MulticastDNS = true;
      dhcpV4Config.UseDNS = false;
      dhcpV6Config.UseDNS = false;
      networkConfig.DNS = [ "1.1.1.1" "1.0.0.1" ];
    };

    "p4net" = {
      matchConfig.Name = "wg-p4net";
      networkConfig.DNS = [ "198.18.1.1" ];
      networkConfig.Address = "198.18.2.2/16";
      networkConfig.Domains = [ "p4" ];
      networkConfig.DNSDefaultRoute = false;
      networkConfig.DNSSEC = false;
    };
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  documentation.nixos.enable = false;

  security.pki.certificateFiles = [ "/root/ca/ca.crt" ];
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  services.resolved = {
    enable = true;
    extraConfig = ''
      MulticastDNS=true
    '';
  };

  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;

  #programs.gnupg = {
  #  agent.enable = true;
  #};

  virtualisation.docker.enable = true;

  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    permitRootLogin = "prohibit-password";
    startWhenNeeded = true;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  fonts.fonts = with pkgs; [ noto-fonts noto-fonts-cjk noto-fonts-emoji ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

}

