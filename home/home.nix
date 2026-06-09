{ config, pkgs, lib, homeDirectory, configHome, ... }:

{
  home.username = config._module.args.username;
  home.homeDirectory = homeDirectory;
  programs.home-manager.enable = true;
  
  xdg = {
    enable = true;
    mime.enable = true;
    mimeApps = {
      enable = true;
    };
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      user.name = "Kari Naga";
      user.email = "4119937+kari-naga@users.noreply.github.com";
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      gpg = {
        format = "ssh";
      };
      "gpg \"ssh\"" = {
        program = "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
      };
      commit = {
        gpgsign = true;
      };
      user = {
        signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA1TB1eyN2NcLI/DhHmA6gxmY4W/+VXtMt29bDpp2jdq";
      };
    };
  };

  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host *
          IdentityAgent ${config.home.homeDirectory}/.1password/agent.sock
    '';
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "26.11"; # Please read the comment before changing.
}
