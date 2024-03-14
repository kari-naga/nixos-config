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
      "${configHome}/foot"
      # "${configHome}/gtk-3.0"
      # "${configHome}/gtk-4.0"
    ] ++ map (directory: {
      directory = strip directory;
      method = "symlink";
    }) [
      config.xdg.userDirs.desktop
      config.xdg.userDirs.documents
      config.xdg.userDirs.music
      config.xdg.userDirs.pictures
      config.xdg.userDirs.videos
    ];
  };
}