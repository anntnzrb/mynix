# desktop.nix --- Desktop configurations for all hosts

{ config, lib, pkgs, inputs, user, ... }:

{
  imports = [ ./shared.nix ];

  # ---------------------------------------------------------------------------
  # system
  # ---------------------------------------------------------------------------

  virtualisation.docker.enable = true;

  # ---------------------------------------------------------------------------
  # windowing system
  # ---------------------------------------------------------------------------
  # X11
  ## configuration should be set using home-manager, the following are very
  ## general rules, e.g: X11 not to launch automatically, disable DM, etc...

  services.xserver = {
    enable = true;
    autorun = false;
    displayManager.startx.enable = true;

    # libinput
    libinput = {
      enable = true;
      mouse.accelProfile = "flat";
    };
  };

  # ---------------------------------------------------------------------------
  # users
  # ---------------------------------------------------------------------------

  users.users.${user} = {
    isNormalUser    = true;
    initialPassword = "root";
    extraGroups     = [ "wheel" "networkmanager" "vboxusers" "docker" ];
    shell = pkgs.zsh;
  };

  # ---------------------------------------------------------------------------
  # packages
  # ---------------------------------------------------------------------------
  # the following should be essential-only packages

  environment.systemPackages = with pkgs; [
    # misc
    woeusb # flash Windows iso
  ];

  # ---------------------------------------------------------------------------
  # fonts
  # ---------------------------------------------------------------------------

  fonts = {
    enableDefaultFonts = true;
    fontconfig = {
      enable = true;
      antialias = true;
      hinting.enable = true;
    };
    fonts = with pkgs; [
      fantasque-sans-mono
      fira-code
      font-awesome
      inconsolata
      iosevka
      jetbrains-mono
      mononoki
      times-newer-roman
    ];
  };

  # ---------------------------------------------------------------------------
  # services
  # ---------------------------------------------------------------------------

  services = {
    # audio -- FIXME :: move to home-manager whenever available
    pipewire = {
      enable = true;
      audio.enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
  };
}
