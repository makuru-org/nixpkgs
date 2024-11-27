{
  lib,
  ...
}:
with lib;
{
  imports = [ ../profiles/qemu-guest.nix ];

  services.openssh = {
    enable = true;

    settings.PermitRootLogin = "prohibit-password";
    settings.PasswordAuthentication = mkDefault false;
  };

  # lyritras uses static networking, with cloud init.
  networking.useDHCP = false;

  fileSystems."/" = {
    fsType = "btrfs";
    device = "/dev/disk/by-partlabel/nixos";
    autoResize = true;
  };
  fileSystems."/boot" = {
    fsType = "vfat";
    device = "/dev/disk/by-partlabel/nixosBoot";
  };

  services.cloud-init.enable = lib.mkDefault true;

  boot.loader.systemd-boot.enable = true;
}
