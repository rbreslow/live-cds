{
  description = "Live CD for generating private keys with GnuPG.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = { self, home-manager, nixpkgs, ... }: {
    nixosConfigurations = {
      default = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            # The default user in the Live CD environment is nixos.
            home-manager.users.nixos = import ./home.nix;
          }
          ({ config, pkgs, ... }: {
            # Newest kernels might not be supported by ZFS yet. If you are
            # running an newer kernel which is not yet officially supported by
            # zfs, the zfs module will refuse to evaluate and show up as broken.
            boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;

            environment.systemPackages = [
              pkgs.cdrtools
              # https://www.jabberwocky.com/software/paperkey/
              pkgs.paperkey
              # TODO: What's the difference between yubikey-manager and
              # yubikey-personalization? I'm only installing the latter due to
              # this reccomendation: https://nixos.wiki/wiki/Yubikey.
              pkgs.yubikey-manager
            ];

            # https://ludovicrousseau.blogspot.com/2019/06/gnupg-and-pcsc-conflicts.html
            services.pcscd.enable = true;
            services.udev.packages = [ pkgs.yubikey-personalization ];
          })
        ];
      };
    };
  };
}
