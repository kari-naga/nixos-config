{ config, pkgs, lib, persistentStoragePath, configHome, strip, ... }:

{
  home.persistence.${persistentStoragePath} = {
    allowOther = true;
    directories = [
      ".vscode"
      "${configHome}/Code"
      "${configHome}/microsoft-edge"
      "${configHome}/dotfiles"
      "${configHome}/Code"
      "${configHome}/hypr"
      "${configHome}/waybar"
      "${configHome}/zsh"
      "${configHome}/dunst"
      "${configHome}/rog"
      (strip config.xdg.userDirs.desktop)
      (strip config.xdg.userDirs.documents)
      (strip config.xdg.userDirs.music)
      (strip config.xdg.userDirs.pictures)
      (strip config.xdg.userDirs.videos)
    ];
  };
}