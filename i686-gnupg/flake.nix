{  
  description = "Live CD for generating private keys with GnuPG.";

  inputs = {
    # Using Nix stable to increase the likelihood of i686 packages being cached.
    nixpkgs.url = "github:nixos/nixpkgs/release-21.05";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = { self, home-manager, nixpkgs, ... }: {
    nixosConfigurations = {
      default = nixpkgs.lib.nixosSystem {
        system = "i686-linux";
        modules = [
          "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            # The default user in the Live CD environment is nixos.
            home-manager.users.nixos = import ./home.nix;
          }
          ({ pkgs, ... }: {
            boot.kernelPackages = pkgs.linuxPackages_latest;
            # This is to support the Pentium M processor on the ThinkPad X41.
            # https://askubuntu.com/questions/117744/how-can-i-install-on-a-non-pae-cpu-error-kernel-requires-features-not-present
            boot.kernelParams = [ "forcepae" ];

            environment.systemPackages = [ 
              # TODO: What's the difference between yubikey-manager and
              # yubikey-personalization? I'm only installing the latter due to
              # this reccomendation: https://nixos.wiki/wiki/Yubikey.
              pkgs.yubikey-manager
              # https://www.jabberwocky.com/software/paperkey/
              pkgs.paperkey 
            ];

            services.udev.packages = [ pkgs.yubikey-personalization ];
          })
        ];
      };
    };
  };
}
