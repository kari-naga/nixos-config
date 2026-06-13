{
  nixConfig = {
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia";
    };
    impermanence.url = "github:nix-community/impermanence";
  };
  outputs =
    {
      self,
      nixpkgs,
      lanzaboote,
      disko,
      home-manager,
      impermanence,
      noctalia-greeter,
      ...
    }@attrs:
    let
      system = "x86_64-linux";
      hostname = "sapphire";
      username = "atom";
      persistent = "/persistent";
      maindisk = "/dev/disk/by-diskseq/1";
      mainpartition = "/dev/disk/by-partlabel/disk-main-root";
      args = {
        inherit
          hostname
          username
          persistent
          maindisk
          mainpartition
          ;
      };
    in
    {
      nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
        specialArgs = attrs;
        modules = [
          { _module = { inherit args; }; }
          ./configuration.nix
          lanzaboote.nixosModules.lanzaboote
          disko.nixosModules.disko
          ./disko-config.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              sharedModules = [
                "${impermanence}/home-manager.nix"
                attrs.noctalia.homeModules.default
                { _module = { inherit args; }; }
              ];
              users.${username} = import ./home;
            };
          }
          impermanence.nixosModules.impermanence
          noctalia-greeter.nixosModules.default
        ];
      };
    };
}
