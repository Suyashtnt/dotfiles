# the maybe good dotfiles
## idk
this repo relies that you use nixOS and that you have 3 partitions labled:
- root
- BOOT
- BulkStorage (optional)

BOOT is an fat partition for booting into the OS
root is a btrfs partition with the following subvolumes:
- root
- nix
- home
BulkStorage is an ext4 partition. Remove the part in hardware-configuration.nix if you don't use it

the repo MUST be cloned into ~/dotfiles. It relies numerous times that its cloned there.

## obligatory screenshots
### NEW
![new neofetch](https://user-images.githubusercontent.com/45307955/178158689-225577bc-9dfa-434e-98b9-19ecffaa61b0.png)
### OLD (to update)
![alternative neofetch](https://user-images.githubusercontent.com/45307955/177975823-18ef9724-4aef-4e59-a6a7-e502c6194a49.png)
![neovim/neovide](https://user-images.githubusercontent.com/45307955/177888338-1867f86e-c288-4af8-86df-f6c52594b5e8.png)
![music player](https://user-images.githubusercontent.com/45307955/177888368-9792007d-f4cc-484d-9760-ad48e3f4d55c.png)
