<h1 align="center"> the maybe good (NixOS) dotfiles </h1>
<h2 align="center"> <i>I think they are pretty good</i> </h2>

# VERY BAIE OLD, check out my commafiles now at <https://github.com/Suyashtnt/commafiles>

## Install

1. Grab and flash the latest NixOS ISO
2. Boot up into it and format your drives
3. Enter the following (steps taken from https://github.com/rxyhn/dotfiles/blob/28b6550c4b812ff0edaa0db14d22ea107d8fd9a0/.github/README.md)
Replace GAMER-PC with the system you want (currently available: `GAMER-PC`)

```bash
# Switch to root user:
sudo su -

# Get into a Nix shell with Nix unstable and git
nix-shell -p git nixUnstable

# Clone my dotfiles
git clone https://github.com/Suyashtnt/dotfiles /mnt/etc/nixos

# Remove this file
rm /mnt/etc/nixos/systems/GAMER-PC/hardware-configuration.nix

# Generate a config and copy the hardware configuration, disregarding the generated configuration.nix
nixos-generate-config --root /mnt
cp /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos/systems/GAMER-PC/hardware-configuration.nix
rm /mnt/etc/nixos/configuration.nix

# Make sure you're in the configuration directory
cd /mnt/etc/nixos

# Install desktop config
nixos-install --flake '.#GAMER-PC'
```

4. Once you are into Hyprland, reclone the dotfiles into `~/dotfiles`

the repo **MUST** be cloned into ~/dotfiles. It relies that its cloned there.

## Obligatory screenshots

<https://user-images.githubusercontent.com/45307955/204083443-4c586a4f-2a16-43d7-9ddc-bf274814a8d9.mp4>

### Older ones

![Image of desktop](https://cdn.discordapp.com/attachments/273539705595756544/1041109605268328538/image.png)
![Another one](https://cdn.discordapp.com/attachments/273539705595756544/1041109217534296124/image.png)
![Firefox theme + github theme](https://user-images.githubusercontent.com/45307955/202266026-843597c3-8f46-45bc-b289-d1bbe192a050.png)

## Inspired by

- @sioodmy The basis of my original hyprland config. Helped a lot with nvidia. Stole a bit of their config for getting hyprland to work + some of their catppuccin modules
- @rxyhn Their rices got me into ricing. I also may or may not have stolen a few (like 6) of their modules
