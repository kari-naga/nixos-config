# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, hyprland, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader
  boot.loader.efi.canTouchEfiVariables = true;
  # boot.loader.systemd-boot.enable = true;

  # Lanzaboote
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };

  boot.initrd.postDeviceCommands = lib.mkAfter ''
    mkdir /btrfs_tmp
    mount /dev/nvme1n1p2 /btrfs_tmp # change if necessary
    if [[ -e /btrfs_tmp/root ]]; then
        mkdir -p /btrfs_tmp/old_roots
        timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
        mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
    fi

    delete_subvolume_recursively() {
        IFS=$'\n'
        for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
            delete_subvolume_recursively "/btrfs_tmp/$i"
        done
        btrfs subvolume delete "$1"
    }

    for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
        delete_subvolume_recursively "$i"
    done

    btrfs subvolume create /btrfs_tmp/root
    umount /btrfs_tmp
  '';

  # boot.initrd.systemd.services.wipe-root = {
  #   description = "Wipe root filesystem on boot";
  #   wantedBy = [
  #     "initrd.target"
  #   ];
  #   after = [
  #     "initrd-root-device.target"
  #   ];
  #   before = [
  #     "sysroot.mount"
  #   ];
  #   path = with pkgs; [
  #     btrfs-progs
  #   ];
  #   unitConfig.DefaultDependencies = "no";
  #   serviceConfig.Type = "oneshot";
  #   script = ''
  #     mkdir /btrfs_tmp
  #     mount /dev/nvme1n1p2 /btrfs_tmp
  #     if [[ -e /btrfs_tmp/root ]]; then
  #         mkdir -p /btrfs_tmp/old_roots
  #         timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
  #         mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
  #     fi

  #     delete_subvolume_recursively() {
  #         IFS=$'\n'
  #         for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
  #             delete_subvolume_recursively "/btrfs_tmp/$i"
  #         done
  #         btrfs subvolume delete "$1"
  #     }

  #     for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
  #         delete_subvolume_recursively "$i"
  #     done

  #     btrfs subvolume create /btrfs_tmp/root
  #     umount /btrfs_tmp
  #   '';
  # };

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
  time.timeZone = "US/Eastern";
  time.hardwareClockInLocalTime = true;

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
  users = {
    mutableUsers = false;
    users.${config._module.args.username} = {
      isNormalUser = true;
      description = "Kari Naga";
      extraGroups = [ "networkmanager" "wheel" "video" ];
      hashedPasswordFile = "${config._module.args.persistent}/passwd/${config._module.args.username}.yescrypt";
      shell = pkgs.zsh;
    };
    users.root.hashedPasswordFile = "${config._module.args.persistent}/passwd/root.yescrypt";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim
    wget
    git
    gnupg
    foot
    wofi
    # asusctl
    # supergfxctl
    usbutils
    xorg.xhost
    gnome.nautilus
    microsoft-edge
    gparted
    sbctl
    libva
    nvidia-vaapi-driver
    libsForQt5.qt5.qtwayland
    libsForQt5.qt5ct
    qt6.qtwayland
    qt6Packages.qt6ct
    gnome.adwaita-icon-theme
    xdg-desktop-portal-gtk
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
  services.asusd.enable = true;
  services.asusd.enableUserService = true;
  services.gnome.gnome-keyring.enable = true;

  programs.zsh.enable = true;
  programs.light.enable = true;
  programs.dconf.enable = true;

  # In progress (https://wiki.archlinux.org/title/Laptop/ASUS)
  systemd.services."battery-charge-threshold" = {
    description = "Set the battery charge threshold";
    after = [ "multi-user.target" ];
    startLimitBurst = 0;
    serviceConfig = {
      Type = "oneshot";
      Restart = "on-failure";
      ExecStart = "/run/current-system/sw/bin/bash -c 'echo 80 > /sys/class/power_supply/BAT1/charge_control_end_threshold'";
    };
    wantedBy = [ "multi-user.target" ];
  };
  powerManagement.resumeCommands = ''
    echo 80 > /sys/class/power_supply/BAT0/charge_control_end_threshold
  '';

  fileSystems.${config._module.args.persistent}.neededForBoot = lib.mkForce true;

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };

  nix.optimise.automatic = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
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

  # https://sawyershepherd.org/post/hibernating-to-an-encrypted-swapfile-on-btrfs-with-nixos/
  boot.resumeDevice = "/dev/nvme1n1p2";
  systemd.sleep.extraConfig = ''
    [Sleep]
    HibernateMode=shutdown
  '';
  
  boot.kernelParams = [
    "quiet"
    "splash"
    "loglevel=3"
    "systemd.show_status=auto"
    "rd.udev.log_level=3"
    "udev.log_level=3"
    "rd.systemd.show_status=false"
    "udev.log_priority=3"
    "boot.shell_on_fail"
    "i915.force_probe=7d55"
    "acpi_backlight=native"
    "i915.enable_dpcd_backlight=1"
    "resume_offset=8922368" # https://sawyershepherd.org/post/hibernating-to-an-encrypted-swapfile-on-btrfs-with-nixos/
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
  ];
  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false;
  boot.loader.timeout = 3;
  boot.plymouth.enable = true;
  # boot.initrd.systemd.enable = true;

  # boot.extraModprobeConfig = ''
  #   options snd-hda-intel model=asus-zenbook
  # '';

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      # edit bus IDs as needed (sudo lshw -c display)
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  sound.enable = false;
  sound.mediaKeys.enable = false;
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

  security.sudo.extraConfig = ''
    Defaults lecture = never
  '';

  security.polkit.enable = true;
  security.rtkit.enable = true;
  xdg.portal.wlr.enable = true;
  services.dbus.enable = true;

  programs.hyprland = {
    enable = true;
    package = hyprland.packages.${pkgs.system}.hyprland;
    xwayland.enable = true;
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  swapDevices = lib.mkForce [ { device = "/swap/swapfile"; } ];

  programs.fuse.userAllowOther = true;

  environment.persistence.${config._module.args.persistent} = {
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/systemd"
      "/var/cache"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/etc/NetworkManager/system-connections"
      "/etc/secureboot"
    ];
    files = [
      "/etc/machine-id"
    ];
    users.${config._module.args.username} = {
      directories = [
        ".cache"
        { directory = ".gnupg"; mode = "0700"; }
        { directory = ".ssh"; mode = "0700"; }
        ".local/share"
        ".local/state"
      ];
    };
  };

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" "Meslo" ]; })
  ];
}
