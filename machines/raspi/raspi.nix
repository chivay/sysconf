{ config, pkgs, lib, ... }: {
  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;
  boot.loader.raspberryPi.enable = true;
  boot.loader.raspberryPi.version = 3;
  boot.loader.raspberryPi.uboot.enable = true;
  boot.loader.raspberryPi.firmwareConfig = ''
    gpu_mem=256
  '';
  boot.kernelPackages = pkgs.linuxPackages_latest;

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes ca-references
    '';
  };
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };

  };
  environment.systemPackages = [ pkgs.htop pkgs.neovim pkgs.libraspberrypi ];

  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 30d";

  users.users = {
    chivay = {
      extraGroups = [ "wheel" ];
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        ''
          ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDY34ZuJ3+eaHU2Ctm44VRANpusZHfpHRxtGILPCObXErY3bqe8YJffCW2
          htyVvE3e6tjEY2PY3s/8tKv1VZ8QM+Lnv3xDiwnsYnNz1y5KbDha9frym+c3OGHqeMD8iLoei3kuxBgYorKBM8CvK0s1sggj13lfY4No
          fNx+DtmBR3lG8lLE0Tj8zHM7S5S3uneKgOLeyaD4+TJBytwPj0f/Xrgq4u3i+8he1NAHChBuR6DoU2MSMoti9Iu8q6HvtE3d7c54TU5G
          W1QjPP59Of9gF0RLe1v1cbYL+cYkmXhib+OfZe7hB1K5W+0TvmCRC2upXGFz7dYYfndw7G6wmWwXK0txkmUszkrvE2ss8SGdMPts73Nn
          EmIkjnDVXSL1sM3yWUv/8mq94o/SkglfZFnJUAsSgV/GjAHwwIhupBT0UXHBciJs4Ht6eBtZSp+kqB010nLqmnzys21pBTeCR8lkv/44
          6J1hceGqYrIoSV+sa3w3cdnScUSmRa85MedBVlSF3GD7Oj5K9KwWDspgt6DX7ksP5vKIHyvIfxGxSMun25XWe6kmsMPdKGdxYUCgyuOy
          xAf0v+EXVrN1W6UXTXuclScPXBEwhuRPJGSgD5UN7fk//GQWmiVulud1ACCM2Ux4TwMekWhqdPohu6Bhl9wppLJcr+CPOBLiYyu/vO66
          lgw== chivay@arnold''
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFHL/kB8ntXpTs2YrH5NBbo/jvROm/J1kRiZ8sTl7Zbc chivay@xakep"
      ];
    };
  };
  users.mutableUsers = false;
  documentation.enable = false;
  security.sudo.wheelNeedsPassword = false;

  systemd.network.enable = true;
  networking.interfaces.eth0.useDHCP = true;
  networking = {
    firewall.enable = false;
    hostName = "raspi";
    useNetworkd = true;
    useDHCP = false;
  };
  services.resolved = {
    enable = true;
    dnssec = "false";
  };

  services.timesyncd.enable = true;
  services.sshd.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  imports = [];
}
