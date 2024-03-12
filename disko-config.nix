{
  disko.devices = {
    disk = {
      vdb = {
        type = "disk";
        device = "/dev/nvme1n1";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              priority = 1;
              name = "ESP";
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ]; # Override existing partition
                # Subvolumes must set a mountpoint in order to be mounted,
                # unless their parent is mounted
                subvolumes = {
                  # Subvolume name is different from mountpoint
                  "/root" = {
                    mountOptions = [ "compress=zstd" ];
                    mountpoint = "/";
                  };
                  "/persistent" = {
                    mountOptions = [ "compress=zstd" ];
                    mountpoint = "/persistent";
                  };
                  # Parent is not mounted so the mountpoint must be set
                  "/nix" = {
                    mountOptions = [ "compress=zstd" "noatime" ];
                    mountpoint = "/nix";
                  };
                  # Subvolume for the swapfile
                  "/swap" = {
                    mountOptions = [ "noatime" ];
                    mountpoint = "/swap";
                    swap = {
                      swapfile.size = "32G";
                    };
                  };
                };
                swap = {
                  swapfile = {
                    size = "32G";
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}

