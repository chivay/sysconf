{ config, pkgs, ... }:
let 
  fetchGitHubKeys = { username , hash }: let
      data = builtins.fetchurl {
        url = "https://github.com/${username}.keys";
        sha256 = hash;
      };
      in pkgs.lib.splitString "\n" (builtins.readFile data);
  myKeys = fetchGitHubKeys {
      username = "chivay";
      hash = "19ynsbjzcqm1bppj37mvk377yqyj6lcal5pb46hd1a2lqddy37r8";
    };
in
{
  imports =
    [
      #<nixos-hardware/lenovo/thinkpad/x250>
      ./hardware-configuration.nix
    ];

  # Enable flakes
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  nixpkgs.config.allowUnfree = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.supportedFilesystems = [ "btrfs" ];
  boot.initrd.network.ssh.enable = true;
  boot.initrd.network.ssh.authorizedKeys = myKeys;

  hardware.enableAllFirmware = true;

  hardware.bluetooth.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "xakep";
  networking.wireless.iwd.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Warsaw";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  #networking.interfaces.enp0s25.useDHCP = true;
  networking.interfaces.wlan0.useDHCP = true;

  networking.useNetworkd = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  security.rtkit.enable = true;
  services.pipewire.enable = true;
  services.pipewire.pulse.enable = true;

  services.resolved = {
    enable = true;
  };

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      swaylock
      swayidle
      wl-clipboard
      mako
      alacritty
      dmenu
    ];
  };

  virtualisation.docker.enable = true;
  virtualisation.xen = {
    enable = true;
    package = pkgs.xen-light;
  };

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
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

  users.users.chivay = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = myKeys;
  };

}

