{ config, pkgs, lib, persistentStoragePath, configHome, strip, ... }:

{
  home.persistence.${persistentStoragePath} = {
    directories = [
      ".cache"
      { directory = ".gnupg"; mode = "0700"; }
      { directory = ".ssh"; mode = "0700"; }
      { directory = ".nixops"; mode = "0700"; }
      { directory = ".local/share/keyrings"; mode = "0700"; }
      ".local/share"
      ".local/state"
      configHome
#       "${configHome}/dotfiles"
#       "${configHome}/microsoft-edge"
#       "${configHome}/1Password"
#       "${configHome}/zsh"
    ] ++ map (directory: {
      directory = strip directory;
    }) [
      config.xdg.userDirs.desktop
      config.xdg.userDirs.documents
      config.xdg.userDirs.music
      config.xdg.userDirs.pictures
      config.xdg.userDirs.videos
    ];
    files = [
      ".screenrc"
    ];
  };
}
