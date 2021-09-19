{config, lib, pkgs, ...}:
{
	boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
	boot.kernelModules = [ "wl" ]; # set of kernel modules loaded in second stage of boot process
	boot.initrd.kernelModules = [ "kvm-intel" "wl" ]; # list of modules always loaded by the initrd (initial ramdisk)
	hardware.opengl.driSupport32Bit = true;

	# Enable CUPS to print documents.
	# https://nixos.wiki/wiki/Printing
	services.printing = {
		enable = true;
		drivers = with pkgs; [
			# Pixma
			cnijfilter2
		];
	};
}

