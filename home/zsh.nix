{
  config,
  lib,
  configHome,
  ...
}:

{
  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    shellAliases = {
      nix-switch = "sudo -i nixos-rebuild switch --flake '${config.xdg.configHome}/dotfiles#sapphire'";
      ls = "ls --color=auto";
    };
    history = {
      path = "${config.xdg.configHome}/zsh/.zsh_history";
      size = 1000;
      save = 1000;
    };
    initContent =
      let
        earlyConfig = lib.mkBefore ''
          if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
            source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
          fi
        '';
        config = ''
          bindkey "^V" ""
          autoload -Uz promptinit
          promptinit
          prompt powerlevel10k
          [[ ! -f ''${ZDOTDIR}/.p10k.zsh ]] || source "''${ZDOTDIR}/.p10k.zsh"
        '';
      in
      lib.mkMerge [
        earlyConfig
        config
      ];
    antidote = {
      enable = true;
      plugins = [
        # completions
        # mattmc3/ez-compinit
        "zsh-users/zsh-completions kind:fpath path:src"

        # frameworks
        "getantidote/use-omz"
        "ohmyzsh/ohmyzsh path:lib"
        "ohmyzsh/ohmyzsh path:plugins/colored-man-pages"
        "ohmyzsh/ohmyzsh path:plugins/magic-enter"

        # normal plugins
        "mattmc3/zfunctions"
        "zsh-users/zsh-autosuggestions"
        "zsh-users/zsh-history-substring-search"

        # defer
        "zdharma-continuum/fast-syntax-highlighting kind:defer"

        # prompt
        "romkatv/powerlevel10k kind:fpath"
      ];
    };
  };
  home.file."${configHome}/zsh/.p10k.zsh" = {
    source = ./files/.p10k.zsh;
  };
}
