{config, lib, pkgs, ...}:
{
	hardware.raspberry-pi."4".fkms-3d.enable = true;
	boot.kernelPackages = pkgs.linuxPackages_5_4;
	#boot.kernelPackages = pkgs.linuxPackages_rpi4;
}

