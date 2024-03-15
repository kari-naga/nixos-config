{ config, pkgs, lib, homeDirectory, configHome, ... }:

{
  home.username = config._module.args.username;
  home.homeDirectory = homeDirectory;
  programs.home-manager.enable = true;
  home.stateVersion = "23.11";
  home.packages = with pkgs; [
    vscode
    waybar
    hyprpaper
    hyprpicker
    hypridle
    hyprlock
    wl-clipboard
    nixpkgs-fmt
    nil
    neofetch
    alsa-utils
    pavucontrol
    htop
  ];
  xdg = {
    enable = true;
    mime.enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "inode/directory" = "org.gnome.Nautilus.desktop";
      };
    };
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };
  systemd.user.services = {
    "app-backintime@autostart".Service.ExecStart = pkgs.writeShellScript "no-op" "";
    "app-picom@autostart".Service.ExecStart = pkgs.writeShellScript "no-op" "";
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
    pinentryPackage = pkgs.pinentry-gnome3;
    defaultCacheTtl = 1800;
    maxCacheTtl = 7200;
  };
  services.gnome-keyring.enable = true;
  services.network-manager-applet.enable = true;
  gtk = {
    enable = true;
    theme.name = "Adwaita:dark";
    gtk2.extraConfig = ''
      gtk-application-prefer-dark-theme = true
    '';
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };
  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };
  qt = {
    enable = true;
    platformTheme = "gnome";
    style.name = "adwaita-dark";
  };
}
