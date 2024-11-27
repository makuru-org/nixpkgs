{
  config,
  lib,
  ...
}:

with lib;
{
  imports = [
    ./lyratris-config.nix
    ../image/repart.nix
  ];

  options.virtualisation.lyratrisImage.configFile = mkOption {
    type = types.path;
    default = ./lyratris-config.nix;
    description = ''
      A path to a configuration file which will be placed at `/etc/nixos/configuration.nix`
      and be used when switching to a new configuration.
      If set to `null`, a default configuration is used, where the only import is
      `<nixpkgs/nixos/modules/virtualisation/lyratris-image.nix>`
    '';
  };

  config.boot.uki.name = "BOOTx64";
  config.image.repart = {
    name = "lyratrisNixos";
    compression = {
      enable = true;
      algorithm = "qcow2-compressed";
    };
    seed = "310eaabc-d44a-4f6e-b9a2-5dd8558e4380";
    # sectorSize = 4096;
    mkfsOptions.btrfs = [
      "--checksum xxhash"
      "--metadata single"
    ];
    partitions = {
      "00-esp" = {
        contents."/EFI/BOOT".source = config.system.build.uki;
        repartConfig = {
          Type = "esp";
          Format = "vfat";
          Label = "nixosBoot";
          SizeMinBytes = "2G";
        };
      };
      "50-root" = {
        storePaths = [ config.system.build.toplevel ];
        repartConfig = {
          Type = "root";
          Format = "btrfs";
          Label = "nixos";
          Minimize = "guess";
        };
      };
    };
  };
  meta.maintainers = with maintainers; [ makuru ];
}
