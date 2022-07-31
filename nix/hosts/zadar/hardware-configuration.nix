# hardware-configuration.nix --- Concrete NixOS hardware configuration :: Zadar

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
      [ "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
    kernelModules = [ "kvm-intel" ];
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
    memoryPercent = 35;
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
    #acpilight.enable = true; # enable brightness control via `xbacklight`
    cpu.intel.updateMicrocode =
      lib.mkDefault config.hardware.enableRedistributableFirmware;

    ## GPU
    #nvidia = {
    #  package = config.boot.kernelPackages.nvidiaPackages.stable;
    #  nvidiaSettings = true;
    #  modesetting.enable = true; # TODO :: testing
    #  powerManagement.enable = true; # graphical glitches on suspend fix
    #};
  };

  # ---------------------------------------------------------------------------
  # network
  # ---------------------------------------------------------------------------

  networking = {
    interfaces = {
      enp4s0.useDHCP = lib.mkDefault true;
      wlp3s0.useDHCP = lib.mkDefault true;
    };
  };
}
