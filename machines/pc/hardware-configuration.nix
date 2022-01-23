{ pkgs, lib, config, ... }:
{
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.availableKernelModules = [ "vmd" "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "i915" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.extraModprobeConfig = ''
  options kvm_intel nested=1
  options kvm_intel emulate_invalid_guest_state=0
  options kvm ignore_msrs=1 report_ignored_msrs=0
  '';

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/ca639ffd-90cb-4586-b228-ee33da949f8f";
      fsType = "btrfs";
      options = [ "subvol=root" ];
    };

  boot.initrd.luks.devices."root".device = "/dev/disk/by-uuid/b7e63b84-348a-492a-ade2-d9972fcb2dd6";

  fileSystems."/home" =
    {
      device = "/dev/disk/by-uuid/ca639ffd-90cb-4586-b228-ee33da949f8f";
      fsType = "btrfs";
      options = [ "subvol=home" "noatime" "compress=zstd" ];
    };

  fileSystems."/persist" =
    {
      device = "/dev/disk/by-uuid/ca639ffd-90cb-4586-b228-ee33da949f8f";
      fsType = "btrfs";
      options = [ "subvol=persist" "noatime" "compress=zstd" ];
    };

  fileSystems."/nix" =
    {
      device = "/dev/disk/by-uuid/ca639ffd-90cb-4586-b228-ee33da949f8f";
      fsType = "btrfs";
      options = [ "subvol=nix" "noatime" "compress=zstd" ];
    };

  fileSystems."/var/log" =
    {
      device = "/dev/disk/by-uuid/ca639ffd-90cb-4586-b228-ee33da949f8f";
      fsType = "btrfs";
      options = [ "subvol=log" "noatime" "compress=zstd" ];
      neededForBoot = true;
    };

  fileSystems."/var/vms" =
    {
      device = "/dev/disk/by-uuid/ca639ffd-90cb-4586-b228-ee33da949f8f";
      fsType = "btrfs";
      options = [ "subvol=vms" "noatime" "compress=zstd" ];
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/11A9-F7D2";
      fsType = "vfat";
    };
}
