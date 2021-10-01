# Live CDs

This repository contains a collection of Nix Flakes for building bootable ISO images.

## e.g.,

```console
$ nix build '.#nixosConfigurations.default.config.system.build.isoImage'
```
