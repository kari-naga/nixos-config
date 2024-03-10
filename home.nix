{ config, pkgs, lib, ... }:

{
  home.stateVersion = "23.11";
  # home.packages = [];
  programs.home-manager.enable = true;
  programs.zsh = {
    enable = true;
    sessionVariables = {
      SSH_AUTH_SOCK = "$(gpgconf --list-dirs agent-ssh-socket)";
    };
  };
  programs.git = {
    enable = true;
    userName = "Kari Naga";
    userEmail = "4119937+kari-naga@users.noreply.github.com";
    lfs.enable = true;
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      commit.gpgsign = true;
      gpg.format = "ssh";
      user.signingKey = "$HOME/.ssh/id_ed25519.pub";
      credential = {
        helper = "${pkgs.git-credential-manager}/bin/git-credential-manager";
        credentialStore = "gpg";
      };
    };
    aliases = {
      a = "add --all";
      tree = "log --graph --decorate --pretty=oneline --abbrev-commit";
    };
  };
  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
  };
  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentryFlavor = "qt";
    defaultCacheTtl = 1800;
    maxCacheTtl = 7200;
  };
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mainMod" = "SUPER";
      "$terminal" = "kitty";
      "$fileManager" = "dolphin";
      "$menu" = "wofi --show drun";
      monitor = ",preferred,auto,auto";
      # "exec-once": "waybar & hyprpaper";
      # windowrulev2 = [
      #   "suppressevent maximize, class:.*"
      # ];
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };
      bind = [
        "$mainMod, C, killactive,"
        "$mainMod, M, exit,"
        "$mainMod, V, togglefloating,"
        "$mainMod, P, pseudo,"
        "$mainMod, J, togglesplit,"
        "$mainMod, Q, exec, $terminal"
        "$mainMod, E, exec, $fileManager"
        "$mainMod, R, exec, $menu"
      ];
      env = [
        "XCURSOR_SIZE,36"
        "QT_QPA_PLATFORMTHEME,qt6ct"
        "LIBVA_DRIVER_NAME,nvidia"
        "XDG_SESSION_TYPE,wayland"
        "GBM_BACKEND,nvidia-drm"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "WLR_NO_HARDWARE_CURSORS,1"
      ];
    };
  };
}
