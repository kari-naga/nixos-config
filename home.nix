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
  home.username = config._module.args.username;
  home.homeDirectory = homeDirectory;
  programs.home-manager.enable = true;
  home.stateVersion = "23.11";
  home.packages = [
    pkgs.vscode
    pkgs.waybar
    pkgs.hyprpaper
    pkgs.wl-clipboard
  ];
  home.persistence.${persistentStoragePath} = {
    allowOther = true;
    directories = [
      "${configHome}/microsoft-edge"
      "${configHome}/dotfiles"
      "${configHome}/Code"
      "${configHome}/hypr"
      "${configHome}/waybar"
      (strip config.xdg.userDirs.desktop)
      (strip config.xdg.userDirs.documents)
      (strip config.xdg.userDirs.music)
      (strip config.xdg.userDirs.pictures)
      (strip config.xdg.userDirs.videos)
    ];
  };
  xdg = {
    enable = true;
    mime.enable = true;
    mimeApps.enable = false;
    userDirs = {
      enable = true;
      createDirectories = false;
    };
  };
  systemd.user.services = {
    "app-backintime@autostart".Service.ExecStart = pkgs.writeShellScript "no-op" "";
    "app-picom@autostart".Service.ExecStart = pkgs.writeShellScript "no-op" "";
  };
  programs.zsh = {
    enable = true;
    sessionVariables = {
      SSH_AUTH_SOCK = "$(gpgconf --list-dirs agent-ssh-socket)";
    };
    shellAliases = {
      "nix-switch" = "sudo -i nixos-rebuild switch --flake ${config.xdg.configHome}/dotfiles#FusionBolt";
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
      user.signingKey = "~/.ssh/id_ed25519.pub";
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
  programs.waybar = {
    enable = true;
    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: Source Code Pro;
        padding: 0 5px;
      }
      window#waybar {
        background: #16191C;
        color: #AAB2BF;
      }
      #workspaces button {
        padding: 0 5px;
      }
    '';
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        modules-left = [
          "hyprland/workspaces"
          "wlr/taskbar"
        ];
        modules-center = [
          "hyprland/window"
        ];
        modules-right = [
          # "mpd"
          "temperature"
          "network"
          "battery"
          "clock"
          "tray"
        ];
        "hyprland/workspaces" = {
          all-outputs = true;
        };
        "battery" = {
          "format" = "{capacity}% {icon}";
          "format-icons" = [ "" "" "" "" "" ];
        };
        "clock" = {
          "format-alt" = "{:%a, %d. %b  %H:%M}";
        };
      };
    };
  };
  services.network-manager-applet.enable = true;
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mainMod" = "SUPER";
      "$terminal" = "kitty";
      "$fileManager" = "dolphin";
      "$menu" = "wofi --show drun";
      monitor = ",preferred,auto,auto";
      "exec-once" = [
        "hyprpaper"
        "waybar"
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
        "xhost +SI:localuser:root"
      ];
      # windowrulev2 = [
      #   "suppressevent maximize, class:.*"
      # ];
      input = {
        kb_layout = "us";
        kb_variant = "";
        kb_model = "";
        kb_options = "";
        kb_rules = "";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;
        };
      };
      general = {
        gaps_in = 5;
        gaps_out = 20;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "dwindle";
        allow_tearing = false;
      };
      decoration = {
        rounding = 10;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
        "col.shadow" = "rgba(1a1a1aee)";
      };
      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };
      master = {
        new_is_master = true;
      };
      gestures = {
        workspace_swipe = false;
      };
      misc = {
        force_default_wallpaper = -1;
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
        # Move focus with mainMod + arrow keys
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"
        # Switch workspaces with mainMod + [0-9]
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"
        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"
        # Example special workspace (scratchpad)
        "$mainMod, S, togglespecialworkspace, magic"
        "$mainMod SHIFT, S, movetoworkspace, special:magic"
        # Scroll through existing workspaces with mainMod + scroll
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
      ];
      bindm = [        
        # Move/resize windows with mainMod + LMB/RMB and dragging
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
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
