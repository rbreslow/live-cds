# Live CDs

This repository contains a collection of Nix Flakes for building bootable ISO images.

## e.g.,

```console
$ nix build '.#nixosConfigurations.default.config.system.build.isoImage'
. . .
[1/29/31 built] building squashfs.img: Creating 4.0 filesystem on /nix/store/jirycvdinb4j9lcqzxw9nc5xn93dhkk3-squashfs.img, block size 1048576.
building '/nix/store/sg6yzg686ac9vfp3fjv7wm033qsj48f0-nixos-21.05.20211001.e134154-i686-linux.iso.drv'...

$ sudo dd if=result/iso/nixos-21.05.20211001.e134154-i686-linux.iso of=/dev/sdb bs=4M status=progress
166+1 records in
166+1 records out
697303040 bytes (697 MB, 665 MiB) copied, 71.2696 s, 9.8 MB/s

$ sudo eject /dev/sdb
```
