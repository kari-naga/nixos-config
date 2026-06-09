# nixos-config

## Installation

- Load repo onto bootable NixOS installation media
  - Can make secure boot compatible media by first flashing NixOS installer ISO then copying `bootx64.efi`, `grubx64.efi`, and `mmx64.efi` from a signed ISO (e.g. Fedora installer) into `EFI/boot`, replacing any existing files
- Comment out Lanzaboote section and enable `systemd-boot`
- Turn off secure boot and boot into installation media
- Find the proper disk in `/dev`
  - Edit `maindevice` and `mainpartition` in `flake-config.nix` appropriately
- Run `sudo nix --experimental-features "nix-command flakes" run 'github:nix-community/disko/latest#disko-install' -- --write-efi-boot-entries --flake '[absolute path to repo]#mymachine' --disk main [maindisk]`
- Run the following:
```sh
mount [mainpartition] /mnt
cd /mnt/persistent
sudo -s
mkdir passwd
mkpasswd -m yescrypt > [user].yescrypt
mkpasswd -m yescrypt > root.yescrypt
mkdir -p /mnt/persistent/home/[user]/.config/dotfiles
cp -r [absolute path to repo]/* /mnt/persistent/home/[user]/.config/dotfiles
```
- Reboot into NixOS
- Run `sudo sbctl create-keys`
- Disable `systemd-boot` and uncomment the Lanzaboote section, then run `nix-switch` and verify with `sudo sbctl verify`
- Reboot and enable secure boot in setup mode
- Run `sudo sbctl enroll-keys --microsoft`
- Reboot and verify secure boot status with `bootctl status`
