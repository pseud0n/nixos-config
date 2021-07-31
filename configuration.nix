# Edit this configuration file to define what should be installed on
# your system.	Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
## nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
# nix-channel --add https://nixos.org/channels/nixos-unstable nixos
# nix-channel --add https://channels.nixos.org/nixos-21.05 nixos

{ config, lib, pkgs, ... }:

let
	#unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
	user = "alexs";
	home = "/home/${user}";
in {
	imports =
		[ # Include the results of the hardware scan.
			./hardware-configuration.nix
			#./grub-savedefault.nix
			(import "${builtins.fetchTarball https://github.com/rycee/home-manager/archive/release-21.05.tar.gz}/nixos")
			#./home-manager/home.nix
		];

	nixpkgs.config.allowUnfree = true; # proprietary drivers

	nixpkgs.config.packageOverrides = pkgs: {
	        nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
	        	inherit pkgs;
        	};
	};

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
					menuentry "Windows 10" {
				    		chainloader (hd0,0)+1
				  	}
  				'';

			};
		};
	};

	networking.useDHCP = false;

	networking.hostName = "nixos"; # Define your hostname.
	networking.networkmanager.enable = true;
	time.timeZone = "Europe/London";

	# The global useDHCP flag is deprecated, therefore explicitly set to false here.
	# Per-interface useDHCP will be mandatory in the future, so this generated config
	# replicates the default behaviour.
	networking.interfaces.eno1.useDHCP = true;

	# Configure network proxy if necessary
	# networking.proxy.default = "http://user:password@proxy:port/";
	# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

	# Select internationalisation properties.
	i18n.defaultLocale = "en_GB.UTF-8";
	console = {
		font = "Lat2-Terminus16";
		keyMap = "uk";
	};

	xdg.portal.enable = true;
	systemd.services.upower.enable = true;

    programs.xwayland.enable = true;

	services = {
		flatpak.enable = true;
	 	gnome.gnome-keyring.enable = true;
	 	upower.enable = true;

		xserver = {
			enable = true;
            synaptics.accelFactor = "2.0";
			libinput = {
				enable = true;
				mouse.accelProfile = "adaptive";
				mouse.accelSpeed = "2.0";
			};
			displayManager = {
				defaultSession = "sway";
				sddm.enable = true;
			};
			layout = "gb";
		};
	};

	environment.variables = {
		TERMIINAL = "alacritty";
		QT_QPA_PLATFORM = "wayland";
	};

	programs.sway = {
		enable = true;
		wrapperFeatures.gtk = true;
		#extraConfig = builtins.readFile ./home-manager/config/sway/config;
	};

	# Enable CUPS to print documents.
	# https://nixos.wiki/wiki/Printing
	services.printing = {
		enable = true;
		drivers = with pkgs; [
			# Pixma
			cnijfilter2
		];
	};

	hardware.opengl.driSupport32Bit = true;
	hardware.opengl.driSupport = true;
	hardware.opengl.enable = true;
	hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
	hardware.opengl.setLdLibraryPath = true;

	sound.enable = true;
	hardware.pulseaudio = {
		enable = true;
		package = pkgs.pulseaudioFull;
		support32Bit = true;
	};

	programs.fish.enable = true;

	security.doas = {
		enable = true;
		extraRules = [{
		    users = [ user ];
		    keepEnv = true;
		}];
		extraConfig = "permit :wheel";
	};

	home-manager.users."${user}" = import ./home-manager/home.nix; 
	users.users."${user}" = {
		shell = pkgs.fish;
		home = home;
		isNormalUser = true;
		extraGroups = [ "wheel" "video" "networkmanager"]; # Enable ‘sudo’ for the user.
	};

	fonts.fonts = with pkgs; [
#		noto-fonts
#		noto-fonts-cjk
#		noto-fonts-emoji
#		liberation_ttf
#		fira-code
#		fira-code-symbols
#		mplus-outline-fonts
#		dina-font
#		proggyfonts
		(nerdfonts.override { fonts = [ "Hack" "FiraCode" ]; })
	];

	environment.pathsToLink = [ "/libexc" ];

	# List packages installed in system profile. To search, run:
	# $ nix search wget
	environment.systemPackages = with pkgs; [
		sway
		mako

		vim
		nano

		git

		mono
		vulkan-tools

		gparted

		fish
		wget
		curl
		xclip
		pciutils
		usbutils
		wirelesstools
		networkmanager
		unzip
		libsecret
	];

#	system.activationScripts = {
#		swaySetup = ''
#			echo $UID
#			XDG_RUNTIME_DIR=/tmp
#			DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus
#			PATH=$PATH:${lib.makeBinPath [ pkgs.which pkgs.mako pkgs.systemdMinimal ]}
#			systemctl --machine=alexs@.host --user
#			which busctl
#			makoctl reload
#			echo BOMBASS
#		'';
#	};

	boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
	boot.kernelModules = [ "wl" ]; # set of kernel modules loaded in second stage of boot process
	boot.initrd.kernelModules = [ "kvm-intel" "wl" ]; # list of modules always loaded by the initrd (initial ramdisk)

	# Some programs need SUID wrappers, can be configured further or are
	# started in user sessions.
	# programs.mtr.enable = true;
	# programs.gnupg.agent = {
	#	 enable = true;
	#	 enableSSHSupport = true;
	# };

	# List services that you want to enable:

	# Enable the OpenSSH daemon.
	services.openssh.enable = true;

	# Open ports in the firewall.
	# networking.firewall.allowedTCPPorts = [ ... ];
	# networking.firewall.allowedUDPPorts = [ ... ];
	# Or disable the firewall altogether.
	# networking.firewall.enable = false;

	hardware.bluetooth.enable = true;
	services.blueman.enable = true; # If no GUI available

	# This value determines the NixOS release from which the default
	# settings for stateful data, like file locations and database versions
	# on your system were taken. It‘s perfectly fine and recommended to leave
	# this value at the release version of the first install of this system.
	# Before changing this value read the documentation for this option
	# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
	system.stateVersion = "21.05"; # Did you read the comment? No.

}

