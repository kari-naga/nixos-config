{ config, pkgs, lib, configHome, ... }:

{
  programs.zsh = {
    enable = true;
    dotDir = "${configHome}/zsh";
    sessionVariables = {
      SSH_AUTH_SOCK = "$(gpgconf --list-dirs agent-ssh-socket)";
      ZDOTDIR = "${configHome}/zsh";
    };
    shellAliases = {
      nix-switch = "sudo -i nixos-rebuild switch --flake '${config.xdg.configHome}/dotfiles#FusionBolt'";
      ls = "ls --color=auto";
    };
    history = {
      path = "${configHome}/zsh/.zsh_history";
      size = 1000;
      save = 1000;
    };
    initExtraFirst = ''
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi
    '';
    initExtra = ''
      function nvidia-offload {
        export __NV_PRIME_RENDER_OFFLOAD=1
        export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
        export __GLX_VENDOR_LIBRARY_NAME=nvidia
        export __VK_LAYER_NV_optimus=NVIDIA_only
        exec "$1"
      }
      autoload -Uz promptinit
      promptinit
      prompt powerlevel10k
      [[ ! -f ''${ZDOTDIR}/.p10k.zsh ]] || source "''${ZDOTDIR}/.p10k.zsh"
    '';
    antidote = {
      enable = true;
      plugins = [
        "ohmyzsh/ohmyzsh path:lib"
        "zsh-users/zsh-autosuggestions"
        "romkatv/powerlevel10k kind:fpath"
        "zdharma-continuum/fast-syntax-highlighting kind:defer"
      ];
    };
  };
  home.file."${configHome}/zsh/.p10k.zsh" = {
    source = ./files/.p10k.zsh;
  };
}