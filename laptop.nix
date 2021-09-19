{config, lib, pkgs, ...}:
{
	#boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
	#boot.kernelModules = [ "wl" ]; # set of kernel modules loaded in second stage of boot process
	#boot.initrd.kernelModules = [ "kvm-intel" "wl" ]; # list of modules always loaded by the initrd (initial ramdisk)

	#hardware.opengl.driSupport32Bit = true;
	#hardware.opengl = {
	#	driSupport = true;
	#	driSupport32Bit = true;
	#	extraPackages32 = with pkgs.pkgsi686Linux [ libva ];
	#	setLdLibraryPath = true;
	#};

	#hardware.pulseaudio.support32Bit = true;

	## Enable CUPS to print documents.
	## https://nixos.wiki/wiki/Printing
	#services.printing = if isPi then {} else {
	#	enable = true;
	#	drivers = with pkgs; [
	#		# Pixma
	#		cnijfilter2
	#	];
	#};

	# Use the systemd-boot EFI boot loader.
	boot = {
		loader = {
			systemd-boot.enable = true;
			efi = {
				canTouchEfiVariables = true;
			};
			grub = {
				version = 2;
				device = "nodev";
				extraEntries =  ''
					menuentry "Windows" {
							set root=(hd0,1)
				    		chainloader +1
				  	}
  				'';

			};
		};
	};
}

