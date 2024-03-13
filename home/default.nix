{ config, pkgs, lib, ... }:

let
  homeDirectory = "/home/${config._module.args.username}";
  persistentStoragePath = "${config._module.args.persistent}${homeDirectory}";
  removePrefixPath = prefix: path:
    let
      start = lib.splitString "/" prefix;
      tokens = lib.splitString "/" path;
      n = builtins.length start;
      join = builtins.concatStringsSep "/";
    in
    if lib.take n tokens == start
    then join (lib.drop n tokens)
    else join tokens;
  strip = removePrefixPath homeDirectory;
  configHome = strip config.xdg.configHome;
in
{
  imports = map (x: (
    import x { inherit config pkgs lib homeDirectory persistentStoragePath strip configHome; }
  )) [
    ./home.nix
    ./hyprland.nix
    ./waybar.nix
    ./persistent.nix
    ./zsh.nix
  ];
}