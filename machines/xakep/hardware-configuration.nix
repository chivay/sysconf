# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules =
    [ "xhci_pci" "ehci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/b8c4f607-0c61-43fa-8a9e-277b26508947";
    fsType = "btrfs";
    options = [ "subvol=root" "noatime" "nodiratime" ];
  };

  boot.initrd.luks.devices."root".device =
    "/dev/disk/by-uuid/d434331d-6df3-481f-949b-aee920542a48";

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/b8c4f607-0c61-43fa-8a9e-277b26508947";
    fsType = "btrfs";
    options = [ "subvol=home" "noatime" "nodiratime" ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/b8c4f607-0c61-43fa-8a9e-277b26508947";
    fsType = "btrfs";
    options = [ "subvol=nix" "noatime" "nodiratime" ];
  };

  fileSystems."/persist" = {
    device = "/dev/disk/by-uuid/b8c4f607-0c61-43fa-8a9e-277b26508947";
    fsType = "btrfs";
    options = [ "subvol=persist" "noatime" "nodiratime" ];
  };

  fileSystems."/var/log" = {
    device = "/dev/disk/by-uuid/b8c4f607-0c61-43fa-8a9e-277b26508947";
    fsType = "btrfs";
    options = [ "subvol=log" "noatime" "nodiratime" ];
    neededForBoot = true;
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/C539-39B2";
    fsType = "vfat";
  };

  swapDevices = [ ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";
}
