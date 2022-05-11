# hardware-configuration.nix --- Concrete NixOS hardware configuration :: Munich

{ config, lib, pkgs, modulesPath, ... }:

let
  bootLabel = "NIX-BOOT";
  rootLabel = "NIX-ROOT";
in {
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  # ---------------------------------------------------------------------------
  # boot
  # ---------------------------------------------------------------------------

  boot = {
    initrd.availableKernelModules = [
      "vmd" "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod"
    ];
    kernelModules  = [ "kvm-intel" ];
    kernelPackages = pkgs.linuxPackages_latest;
  };

  # ---------------------------------------------------------------------------
  # file-systems
  # ---------------------------------------------------------------------------

  fileSystems."/" = {
    device  = "/dev/disk/by-label/${rootLabel}";
    label   = "${rootLabel}";
    fsType  = "btrfs";
    options = [
      "noatime"
      "space_cache=v2"
      "compress=zstd"
      "ssd"
      "discard=async"
    ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/${bootLabel}";
    label  = "${bootLabel}";
    fsType = "vfat";
  };

  # RAM
  # swap-file/swap-partition disabled; using ZRAM
  swapDevices = [ ];

  zramSwap = {
    enable         = true;
    algorithm      = "zstd";
    memoryPercent  = 25;
  };

  # ---------------------------------------------------------------------------
  # power management
  # ---------------------------------------------------------------------------

  powerManagement = {
    enable = true;
    cpuFreqGovernor = lib.mkDefault "performance";
  };

  # ---------------------------------------------------------------------------
  # hardware
  # ---------------------------------------------------------------------------

  hardware = {
    video.hidpi.enable = true;
    acpilight.enable   = true; # enable brightness control via `xbacklight`
    bluetooth.enable   = true;
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };

  # ---------------------------------------------------------------------------
  # network
  # ---------------------------------------------------------------------------

  networking = {
    interfaces.enp3s0.useDHCP = lib.mkDefault true;
  };
}
