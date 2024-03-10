# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, hyprland, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };

  networking.hostName = config._module.args.hostname; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.wireless.userControlled.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  # networking.networkmanager.unmanaged = [ "*" "except:type:wwan" "except:type:gsm" ];
  networking.firewall.enable = true;

  # Set your time zone.
  time.timeZone = "America/Detroit";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${config._module.args.username} = {
    isNormalUser = true;
    description = "Kari Naga";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    gnupg
    kitty
    wofi
    pkgs.xorg.xhost
    pkgs.libsForQt5.dolphin
    pkgs.microsoft-edge
    pkgs.gparted
    pkgs.sbctl
    pkgs.libva
    pkgs.nvidia-vaapi-driver
    pkgs.libsForQt5.qt5.qtwayland
    pkgs.libsForQt5.qt5ct
    pkgs.qt6.qtwayland
    pkgs.qt6Packages.qt6ct
  ];

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
  system.stateVersion = "23.11"; # Did you read the comment?

  powerManagement.enable = true;

  services.thermald.enable = true;
  services.tlp.enable = true;
  services.fstrim.enable = true;
  services.hardware.bolt.enable = true;
  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # services.gnome.gnome-keyring.enable = lib.mkForce false;
  programs.zsh.enable = true;
  
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
    displayManager = {
      autoLogin = {
        enable = true;
        user = config._module.args.username;
      };
      defaultSession = "hyprland";
      sddm = {
        enable = true;
        wayland.enable = true;
        enableHidpi = true;
      };
    };
    libinput.enable = true;
  };

  boot.kernelParams = [
    "i915.force_probe=7d55"
    "acpi_backlight=vendor"
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
  ];

  # boot.extraModprobeConfig = ''
  #   options i915 force_probe=7d55
  # '';

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  sound.enable = true;
  services.pipewire = {
    enable = true;
    audio.enable = true;
    pulse.enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    jack.enable = true;
  };

  security.polkit.enable = true;
  security.rtkit.enable = true;
  xdg.portal.wlr.enable = true;
  services.dbus.enable = true;

  programs.hyprland = {
    enable = true;
    package = hyprland.packages.${pkgs.system}.hyprland;
    xwayland.enable = true;
  };

  swapDevices = lib.mkForce [ ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  environment.shellAliases = {
    "nix-switch" = "sudo -i nixos-rebuild switch --flake /home/atom/.dotfiles#FusionBolt";
    "xroot-enable" = "xhost +SI:localuser:root";
  };
}
