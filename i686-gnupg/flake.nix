{  
  description = "Live CD for generating private keys with GnuPG.";

  inputs = {
    # Using Nix stable to increase the likelihood of i686 packages being cached.
    nixpkgs.url = "github:nixos/nixpkgs/release-21.05";
  };

  outputs = { self, nixpkgs, ... }: {
    nixosConfigurations = {
      default = nixpkgs.lib.nixosSystem {
        system = "i686-linux";
        modules = [
          "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
          ({ pkgs, ... }: {
            boot.kernelPackages = pkgs.linuxPackages_latest;

            services.pcscd.enable = true;
            services.udev.packages = [ pkgs.yubikey-personalization ];

            environment.systemPackages = [
              pkgs.gnupg
              pkgs.pinentry-curses
              pkgs.pinentry-qt
              # https://www.jabberwocky.com/software/paperkey/
              pkgs.paperkey
            ];

            programs = {
              ssh.startAgent = false;

              gnupg.agent = {
                enable = true;
                enableSSHSupport = true;
              };
            };
          })
        ];
      };
    };
  };
}
