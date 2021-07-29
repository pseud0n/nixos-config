# nixos-config
Current configuration for x86_64 computer running Home Manager & NixOS 21.05 with dual boot.
This uses Wayland Sway.

To use, install NixOS: https://nixos.org/manual/nixos/stable/index.html#sec-obtaining
After, clone this repo, delete `hardware-configuration.nix` and generate the correct one using `nixos-generate-config`.
Inside `configuration.nix`, there is specific configuration for Broadcom wifi, which can be deleted without problem.
