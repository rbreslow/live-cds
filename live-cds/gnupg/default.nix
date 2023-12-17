{ config, lib, pkgs, ... }: 

{
  # Newest kernels might not be supported by ZFS yet. If you are
  # running an newer kernel which is not yet officially supported by
  # zfs, the zfs module will refuse to evaluate and show up as
  # broken.
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;

  # This is to support the Pentium M processor on the ThinkPad X41.
  # https://askubuntu.com/questions/117744/how-can-i-install-on-a-non-pae-cpu-error-kernel-requires-features-not-present
  boot.kernelParams = lib.optionals pkgs.stdenv.isi686 [ "forcepae" ];

  environment.systemPackages = with pkgs; [
    cdrtools
    paperkey # https://www.jabberwocky.com/software/paperkey/
    yubikey-manager # https://nixos.wiki/wiki/Yubikey
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    # The default user in the Live CD environment is nixos.
    users.nixos = import ./home.nix;
  };

  # https://ludovicrousseau.blogspot.com/2019/06/gnupg-and-pcsc-conflicts.html
  services.pcscd.enable = true;
  services.udev.packages = with pkgs; [ yubikey-personalization ];

  # Allow nixos user to burn CDs.
  users.users.nixos.extraGroups = [ "cdrom" ];
}
