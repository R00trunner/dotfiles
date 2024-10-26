# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;
  boot.supportedFilesystems = [ "ntfs" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [
  rtl88xxau-aircrack rtl8188eus-aircrack
  ];
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Africa/Tunis";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ar_TN.UTF-8";
    LC_IDENTIFICATION = "ar_TN.UTF-8";
    LC_MEASUREMENT = "ar_TN.UTF-8";
    LC_MONETARY = "ar_TN.UTF-8";
    LC_NAME = "ar_TN.UTF-8";
    LC_NUMERIC = "ar_TN.UTF-8";
    LC_PAPER = "ar_TN.UTF-8";
    LC_TELEPHONE = "ar_TN.UTF-8";
    LC_TIME = "ar_TN.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the XFCE Desktop Environment.
  services.xserver.displayManager.lightdm.enable = false;
  services.xserver.desktopManager.xfce.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = true;
  services.libinput.enable = true;
   security.polkit.enable = true;
    programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
 };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "ch";
    variant = "fr";
  };

  # Configure console keymap
  console.keyMap = "fr_CH";

  # Enable CUPS to print documents.
  services.printing.enable = true;
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  sound.enable = true;
  hardware.enableAllFirmware = true;
  # Enable sound with pipewire.
  hardware.pulseaudio.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = false;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = false;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
  hardware.pulseaudio.support32Bit = true;
  nixpkgs.config.pulseaudio = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;
  hardware.pulseaudio.extraConfig = "load-module pactl module-equalizer-sink module-dbus-protocol module-ladspa-sink ";
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nixbtw = {
    isNormalUser = true;
    description = "NixBTW";
    extraGroups = [ "networkmanager" "wheel" "vboxusers" "audio" "pulse" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;
  programs.zsh.enable = true;
  programs.hyprland.enable = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  programs.hyprland.xwayland.enable = true;
  services.xserver.windowManager.i3.enable = true;
  hardware.opengl.extraPackages = [ pkgs.mesa.drivers ];
  users.defaultUserShell = pkgs.zsh;
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
   vim wget neovim curl git neofetch htop zsh usbutils mpv wifite2 aircrack-ng bully reaverwps cava wirelesstools netcat-openbsd polkit xwayland dconf pulseaudioFull alsa-tools alsa-lib alsa-utils alsa-oss pavucontrol bluez mpd pamixer mesa glxinfo glfw xorg.xorgserver libdrm wayland-utils wlr-protocols wlroots hyprland-protocols hyprcursor hyprlock xdg-desktop-portal-hyprland xdg-desktop-portal-wlr xdg-desktop-portal hyprland-workspaces libglvnd intel-media-sdk xdg-utils 
   xfce.xfce4-cpufreq-plugin xfce.xfce4-xkb-plugin xfce.xfce4-whiskermenu-plugin xfce.xfce4-pulseaudio-plugin xfce.xfce4-cpugraph-plugin xfce.xfce4-whiskermenu-plugin
   python3Full python311Packages.distutils-extra python311Packages.pexpect gobject-introspection python311Packages.pygobject3 ninja meson gtk3 python311Packages.pycairo  
  ];
  fonts.packages = with pkgs; [
  nerdfonts
  noto-fonts
  noto-fonts-cjk
  noto-fonts-emoji
  font-awesome
  ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;
  services.xserver.videoDrivers = [ "intel" "nvidia " "modesetting" ];
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

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
  system.stateVersion = "24.05"; # Did you read the comment?

}
