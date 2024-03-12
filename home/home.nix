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
  xdg = {
    enable = true;
    mime.enable = true;
    mimeApps = {
      enable = false;
      defaultApplications = {
        "inode/directory" = "nautilus.desktop";
      };
    };
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
    dotDir = "${configHome}/zsh";
    sessionVariables = {
      SSH_AUTH_SOCK = "$(gpgconf --list-dirs agent-ssh-socket)";
      ZDOTDIR = "${configHome}/zsh";
    };
    shellAliases = {
      "nix-switch" = "sudo -i nixos-rebuild switch --flake '${config.xdg.configHome}/dotfiles#FusionBolt'";
    };
    initExtra = ''
      function nvidia-offload {
        export __NV_PRIME_RENDER_OFFLOAD=1
        export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
        export __GLX_VENDOR_LIBRARY_NAME=nvidia
        export __VK_LAYER_NV_optimus=NVIDIA_only
        exec "$1"
      }
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
  services.gnome-keyring.enable = true;
  services.dunst = {
    enable = true;
  };
  services.network-manager-applet.enable = true;
  gtk = {
    enable = true;
    theme.name = "Adwaita-dark";
  };
  qt = {
    enable = true;
    platformTheme = "gtk3";
  };
}
