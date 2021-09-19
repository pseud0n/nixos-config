# Edit this configuration file to define what should be installed on
# your system.	Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

# https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
# https://nixos.org/channels/nixos-unstable unstable
# https://channels.nixos.org/nixos-21.05 nixos


{ config, lib, pkgs, ... }:

let
	#unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
	user = "alexs";
	home = "/home/${user}";
	homeManagerDir = "${home}/nixos/home-manager/config";
	isPi = builtins.currentSystem == "aarch64-linux"; #!= "x86_64-linux";
in {
	imports =
		[ # Include the results of the hardware scan.
			./hardware-configuration.nix
			#./grub-savedefault.nix
			(import "${builtins.fetchTarball https://github.com/rycee/home-manager/archive/release-21.05.tar.gz}/nixos")
			#./home-manager/home.nix
		] ++ (if isPi then [
			"${builtins.fetchTarball https://github.com/NixOS/nixos-hardware/archive/refs/tags/mnt-reform2-nitrogen8m-v1.tar.gz}/raspberry-pi/4"
			#"${builtins.fetchTarball https://github.com/NixOS/nixos-hardware/archive/936e4649098d6a5e0762058cb7687be1b2d90550.tar.gz}/raspberry-pi/4"
			./pi.nix
		] else [
			./laptop.nix
		]);

	nixpkgs.config.allowUnfree = true; # proprietary drivers
#	nixpkgs.config.permittedInsecurePackages = [
#		"libsixel-1.8.6"
#	];

	nixpkgs.config.packageOverrides = pkgs: with pkgs;{
	        nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
	        	inherit pkgs;
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

		mongodb = {
			enable = true;
			dbpath = "${home}/data/db";
			user = "alexs";
		};

		xserver = {
			displayManager = {
				defaultSession = "sway";
				lightdm.greeters.mini = {
					enable = true;
					user = user;
					extraConfig = ''
						[greeter]
						show-password-label = true
						password-alignment = center
						password-label-text = ♥♥♥♥♥
						[greeter-theme]

						[greeter-theme]
						window-color = "#D79921"
						font-size = 1em
						background-image = "./home-manager/config/sway/backgrounds/gruvbox-dark-rainbow.png"
						border-width = 1px
					'';
				};
			};
			layout = "gb";
		};
	};

	environment = {
		variables = {
			#TERMINAL = "alacritty";
			TERMINAL = "foot";
			QT_QPA_PLATFORM = "wayland";
			XDG_CURRENT_DESTKOP = "sway";
			MOZ_ENABLE_WAYLAND = "1";
			_JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=lcd";
			GTK_THEME = "Adwaita:dark";
			DEV_DIR = "$HOME/dev";
			HOME_MANAGER_DIR = homeManagerDir;
		};
		etc = {
			"xdg/gtk-2.0".source = homeManagerDir + "/gtk/gtk-2.0";
			"xdg/gtk-3.0".source = homeManagerDir + "/gtk/gtk-3.0";
		};
	};

	programs.sway = {
		enable = true;
		wrapperFeatures.gtk = true;
	};

	sound.enable = true;
	hardware.pulseaudio = {
		enable = true;
		package = pkgs.pulseaudioFull;
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
		extraGroups = [ "wheel" "video" "networkmanager" "dialout" ]; # Enable ‘sudo’ for the user.
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

		#mono
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

		agenda
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

