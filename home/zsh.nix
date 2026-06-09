{ config, pkgs, lib, configHome, ... }:

{
  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    sessionVariables = {
      ZDOTDIR = "${config.xdg.configHome}/zsh";
    };
    shellAliases = {
      nix-switch = "sudo -i nixos-rebuild switch --flake '${config.xdg.configHome}/dotfiles#sapphire'";
      ls = "ls --color=auto";
    };
  };
}
