# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  utils,
  noctalia,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  # boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.plymouth = {
    enable = true;
  };

  boot.resumeDevice = config._module.args.mainpartition;

  boot.consoleLogLevel = 3;
  boot.initrd.verbose = false;
  boot.kernelParams = [
    # Silent boot
    "quiet"
    "splash"
    "loglevel=3"
    "systemd.show_status=auto"
    "rd.systemd.show_status=auto"
    "udev.log_level=3"
    "rd.udev.log_level=3"
    "udev.log_priority=3"
    "rd.udev.log_priority=3"
    "boot.shell_on_fail"
    # General params
    "i915.force_probe=9a49"
    "i915.enable_guc=3"
    "acpi_backlight=native"
    "i915.enable_dpcd_backlight=1"
    "resume_offset=8658176"
  ];
  boot.loader.timeout = 0;

  boot.initrd.systemd = {
    enable = true; # Default in 26.05
    services.wipe-file-systems = {
      # Specify dependencies explicitly
      unitConfig.DefaultDependencies = false;
      # The script needs to run to completion before this service is done
      serviceConfig.Type = "oneshot";
      # This service is required for boot to succeed
      requiredBy = [ "initrd.target" ];
      # Should complete before any file systems are mounted
      before = [ "sysroot.mount" ];

      # Wait for the disk to appear
      requires = [ "${utils.escapeSystemdPath config._module.args.mainpartition}.device" ];
      after = [
        "${utils.escapeSystemdPath config._module.args.mainpartition}.device"
        # Allow hibernation to resume before trying to alter any data
        "local-fs-pre.target"
      ];

      script = ''
        mkdir /btrfs_tmp
        mount ${config._module.args.mainpartition} /btrfs_tmp
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
    };
  };

  services.xserver.videoDrivers = [ "modesetting" ];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      # Required for modern Intel GPUs (Xe iGPU and ARC)
      intel-media-driver # VA-API (iHD) userspace
      vpl-gpu-rt # oneVPL (QSV) runtime

      # Optional (compute / tooling):
      intel-compute-runtime # OpenCL (NEO) + Level Zero for Arc/Xe
      # NOTE: 'intel-ocl' also exists as a legacy package; not recommended for Arc/Xe.
      # libvdpau-va-gl       # Only if you must run VDPAU-only apps
    ];
  };

  hardware.enableRedistributableFirmware = true;

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD"; # Prefer the modern iHD backend
    # VDPAU_DRIVER = "va_gl";      # Only if using libvdpau-va-gl
  };

  networking.hostName = config._module.args.hostname; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "US/Eastern";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    #     font = "Lat2-Terminus16";
    #     keyMap = "us";
    useXkbConfig = true; # use xkb.options in tty.
  };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  services.pulseaudio.enable = false;
  # OR
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    # jack.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't./files/.p10k.zsh forget to set a password with ‘passwd’.
  users = {
    mutableUsers = false;
    users.${config._module.args.username} = {
      isNormalUser = true;
      description = "Kari Naga";
      extraGroups = [
        "networkmanager"
        "wheel"
        "video"
        "render"
      ];
      hashedPasswordFile = "${config._module.args.persistent}/passwd/${config._module.args.username}.yescrypt";
      shell = pkgs.zsh;
    };
    users.root.hashedPasswordFile = "${config._module.args.persistent}/passwd/root.yescrypt";
  };

  # programs.firefox.enable = true;
  programs.zsh.enable = true;

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "atom" ];
  };

  services.fprintd.enable = true;
  #   services.fprintd.tod.enable = true;
  #   services.fprintd.tod.driver = pkgs.libfprint-2-tod1-elan;

  # services.desktopManager.plasma6.enable = true;
  # services.displayManager.sddm.enable = true;
  # services.displayManager.sddm.wayland.enable = true;

  programs.niri.enable = true;

  programs.noctalia-greeter = {
    enable = true;
    greeter-args = "--session niri";
  };

  # NixOS otherwise injects a stripped PATH via Environment= on the niri.service
  # unit which shadows the imported user-manager PATH. Disabling the default
  # lets niri inherit the full PATH set up by niri-session.
  systemd.user.services.niri.enableDefaultPath = false;

  security.polkit.enable = true; # polkit
  services.gnome.gnome-keyring.enable = true; # secret service

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    gnupg
    usbutils
    sbctl
    e2fsprogs
    nixd
    nil
    noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    # Graphical Applications
    microsoft-edge
    nautilus
    alacritty
    # # KDE Utilities
    # kdePackages.discover
    # kdePackages.kcalc
    # kdePackages.kcharselect
    # kdePackages.kclock
    # kdePackages.kcolorchooser
    # kdePackages.kolourpaint
    # kdePackages.ksystemlog
    # kdePackages.sddm-kcm
    # kdiff3
    # kdePackages.isoimagewriter
    # kdePackages.partitionmanager
    # hardinfo2
    # wayland-utils
    # wl-clipboard
    # vlc
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.nix-ld = {
    enable = true;
    libraries = pkgs.steam-run.args.multiPkgs pkgs;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  powerManagement.enable = true;
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  security.sudo.extraConfig = ''
    Defaults lecture = never
  '';

  environment.persistence.${config._module.args.persistent} = {
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/systemd"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/sbctl"
      "/var/lib/fprint"
      "/var/lib/noctalia-greeter"
      "/var/cache"
      "/etc/NetworkManager/system-connections"
    ];
    files = [
      "/etc/machine-id"
    ];
  };

  fileSystems.${config._module.args.persistent}.neededForBoot = lib.mkForce true;

  swapDevices = lib.mkForce [ { device = "/.swapvol/swapfile"; } ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # nix.nixPath = nix.nixPath ++ [ "/home/atom/.config/dotfiles" ];
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
  nix.optimise.automatic = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?
}
