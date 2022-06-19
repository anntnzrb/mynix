# hardware-configuration.nix --- Concrete NixOS hardware configuration :: Solna

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
    initrd.availableKernelModules =
      [ "ahci" "xhci_pci" "usb_storage" "sd_mod" ];
    kernelPackages = pkgs.linuxPackages_latest;
  };

  # ---------------------------------------------------------------------------
  # file-systems
  # ---------------------------------------------------------------------------

  fileSystems."/" = {
    device = "/dev/disk/by-label/${rootLabel}";
    label = "${rootLabel}";
    fsType = "btrfs";
    options = [ "noatime" "space_cache=v2" "compress=zstd" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/${bootLabel}";
    label = "${bootLabel}";
    fsType = "vfat";
  };

  # RAM
  # swap-file/swap-partition disabled; using ZRAM
  swapDevices = [ ];

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };

  # ---------------------------------------------------------------------------
  # power management
  # ---------------------------------------------------------------------------

  powerManagement = {
    enable = true;
    cpuFreqGovernor = lib.mkDefault "powersave";
  };

  # ---------------------------------------------------------------------------
  # hardware
  # ---------------------------------------------------------------------------

  hardware = {
    acpilight.enable = true; # enable brightness control via `xbacklight`
    cpu.intel.updateMicrocode =
      lib.mkDefault config.hardware.enableRedistributableFirmware;
  };

  # ---------------------------------------------------------------------------
  # network
  # ---------------------------------------------------------------------------

  networking = {
    interfaces = {
      eno1.useDHCP = lib.mkDefault true;
      wlo1.useDHCP = lib.mkDefault true;
    };
  };
}
