# the maybe good dotfiles

## idk

this repo relies that you use nixOS and that you have 4 partitions labled:

- root
- BOOT
- BulkStorage (optional)
- Games (optional)

BOOT is an fat partition for booting into the OS

root is a btrfs partition with the following subvolumes:

- root
- nix
- home

BulkStorage is an ext4 partition. Remove the part in hardware-configuration.nix if you don't use it
Games is an ntfs partition. Remove the part in hardware-configuration.nix if you don't use it

the repo **MUST** be cloned into ~/dotfiles. It relies numerous times that its cloned there.

## obligatory screenshots

![Image of desktop](https://cdn.discordapp.com/attachments/273539705595756544/1041109605268328538/image.png)
![Another one](https://cdn.discordapp.com/attachments/273539705595756544/1041109217534296124/image.png)
![Firefox theme + github theme](https://user-images.githubusercontent.com/45307955/202266026-843597c3-8f46-45bc-b289-d1bbe192a050.png)

### WIP: powermode

![WIP showcase of powermode](https://user-images.githubusercontent.com/45307955/202266864-6738de16-3ebf-41c1-a1ed-1e9526ed5038.png)

https://user-images.githubusercontent.com/45307955/202267624-130ba057-320a-46ee-b3d3-d09a347b9a0a.mp4

## Inspired by

- @sioodmy The basis of my original hyprland config. Helped a lot with nvidia.
- @rxyhn Their rices got me into ricing. I also may or may not have stolen a lot of my refactored config from them.
