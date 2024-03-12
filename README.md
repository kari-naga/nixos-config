# nixos-config

## Installation
 
- Load repo onto bootable NixOS installation media
- Comment out Lanzaboote section and enable `systemd-boot`
- Turn off secure boot and boot into installation media
- Run `lsblk` and check the device name of the target storage (e.g. `nvme1n1`)
  - Edit the `device` field in `disko-config.nix` and the target partition (append `p2` to the device name) under `boot.initrd.postDeviceCommands` in `configuration.nix` appropriately
- Run `sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko [absolute path to repo]/disko-config.nix`
- Use `mkpasswd -m yescrypt` to generate hashed password files for user and root
  - Place them in `/mnt/persistent/passwd` with names `[user].yescrypt`
- Run `sudo nixos-install --flake [absolute path to repo]#FusionBolt`
- Reboot into NixOS
- Run `sudo sbctl create-keys`
- Disable `systemd-boot` and uncomment the Lanzaboote section, then run `nix-switch` and verify with `sudo sbctl verify`
- Reboot and enable secure boot in setup mode
- Run `sudo sbctl enroll-keys --microsoft`
- Reboot and verify secure boot status with `bootctl status`
