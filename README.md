# nixos-config

## Installation

- Load repo onto bootable NixOS installation media
  - Can make secure boot compatible media by first flashing NixOS installer ISO then copying `bootx64.efi`, `grubx64.efi`, and `mmx64.efi` from a signed ISO (e.g. Fedora installer) into `EFI/boot`, replacing any existing files
- Comment out Lanzaboote section and enable `systemd-boot`
- Turn off secure boot and boot into installation media
- Run `lsblk` and check the device name of the target storage (e.g. `nvme1n1`)
  - Edit the `device` field in `disko-config.nix` and the target partition (append `p2` to the device name) under `boot.initrd.postDeviceCommands` in `configuration.nix` appropriately
- Run `sudo lshw -c display` and change the bus IDs for Nvidia Prime in `configuration.nix`
  - Remove leading zeroes, convert from hexadecimal to decimal, and replace periods with colons
  - Only last three numbers needed
- Run `sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko [absolute path to repo]/disko-config.nix`
- Use `mkpasswd -m yescrypt > [user].yescrypt` to generate hashed password files for user and root
  - Place them in `/mnt/persistent/passwd`
- Run `sudo nixos-install --flake [absolute path to repo]#FusionBolt`
- Reboot into NixOS
- Run `sudo sbctl create-keys`
- Disable `systemd-boot` and uncomment the Lanzaboote section, then run `nix-switch` and verify with `sudo sbctl verify`
- Reboot and enable secure boot in setup mode
- Run `sudo sbctl enroll-keys --microsoft`
- Reboot and verify secure boot status with `bootctl status`
