{ config, pkgs, ... }:
with import <nixpkgs> { config = { allowUnfree = true; }; };

let
	nixosConfig = (import <nixpkgs/nixos> {}).config;

	homeConfigDir = /etc/nixos/home-manager/config;

#	unstableTarball = fetchTarball
#      https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz;

	gruvboxTheme = {
		bg = "282828";
		fg = "ebdbb2";
		red = "cc241d";
		green = "98971a";
		yellow = "d79921";
		blue = "458588";
		purple = "b16286";
		aqua = "689d6a";
		orange = "fe8019";
		gray = "a89984";
	};

	defaultFont = "Fira Code";
	pangoFont = n: "${defaultFont} ${builtins.toString n}";
	defaultBackground = gruvboxTheme.bg;
	addAlpha = hex: "${defaultBackground}${hex}";
	defaultBackgroundAlpha = addAlpha "FF";
	#defaultTerminal = nixosConfig.environment.variables.TERMINAL; #"${config.environment.variables.TERMINAL}";
	defaultTerminal = nixosConfig.environment.variables.TERMINAL;
	devDir = nixosConfig.environment.variables.DEV_DIR;

	readConfig = path: builtins.readFile (homeConfigDir + path);
	
	isPi = builtins.currentSystem == "aarch64-linux";

in rec {
#	nixpkgs.config.packageOverrides = pkgs: {
#		nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
#			inherit pkgs;
#		};
#		unstable = import unstableTarball {
#			config = config.nixpkgs.config;
#		};
#    };
	
#	nixpkgs.config.permittedInsecurePackages = [
#		"libsixel-1.8.6"
#	];
	nixpkgs.config.allowUnfree = true;
	#nixpkgs.config.allowBroken = false;
	#allowBrokenPredicate = pkg: builtins.elem (lib.getName pkg) [
	#	"ghc-vis"
	#];
	nixpkgs.config.
	programs.home-manager.enable = true;

	home.username = "alexs";
	home.homeDirectory = nixosConfig.users.users.alexs.home;

#	home.sessionVariables = {
#	};

	home.packages =
		let
			cliMiscPackages = with pkgs; [
#				(import (builtins.fetchFromGitHub {
#					owner = "Shopify";
#					repo = "comma";
#					rev = "4a62ec17e20ce0e738a8e5126b4298a73903b468";
#					sha256 = "0n5a3rnv9qnnsrl76kpi6dmaxmwj1mpdd2g0b4n1wfimqfaz6gi1";
#				}))
				#(import (builtins.fetchTarball "https://github.com/shopify/comma/archive/master.tar.gz") {})

				(import (builtins.fetchGit {
					url = "https://github.com/shopify/comma";
					ref = "master";
					rev = "4a62ec17e20ce0e738a8e5126b4298a73903b468"; 
				}) {})
				#libsixel
				#ffmpeg-sixel
				interception-tools
				#libstdcxx5
				taskwarrior
				imagemagick
				bat
				lxsession
				nix-prefetch-git
				grub2
				lf
				neofetch
				pfetch
				ripgrep
				fd
				flatpak
				lsd
				htop
				hexyl
				jack1
				xboxdrv
				libxkbcommon
				xdg-utils
				libinput
				jq
				pkg-config
				glib-networking
				trash-cli
				xorg.xhost
				xorg.libXcomposite
			];

			guiMiscPackages = with pkgs; [
				gtk-engine-murrine
				gtk_engines
				gsettings-desktop-schemas
				glib
				gtk3
				hicolor-icon-theme
				transmission-remote-gtk
				gnome3.adwaita-icon-theme
				gnome-breeze

				thunderbird
				agenda
				mupdf
				plasma5Packages.kdenlive
				gimp
				webcamoid
				agenda
				pcmanfm
				klavaro
				barrier

				mpv
				sxiv
				dragon-drop
				libnotify
				gnome.networkmanagerapplet
				pavucontrol
				neovim-qt
				element-desktop
				libreoffice
				#firefox-wayland
				epiphany
				alacritty
				foot
				conky
				libappindicator-gtk3
			] ++ (if isPi then [
			] else [
				whatsapp-for-linux
				obsidian
				qtchan
				etcher
				discord
				zoom-us
				wine
				spotify
				virtualbox
				blender
				appimage-run
				postman
				spotify
			]);

			pythonVersion = "python39";

			programmingPackages = with pkgs; [	
				gnumake
				cmake

				gcc10
				#clang_11
				clang-tools
				flex
				bison
				boost
				ccls

				cargo
				rust-analyzer
				rustc
				rustfmt

				gradle
				jdk11
				#openjfx15
				#scenebuilder

				#pkgs."${pythonVersion}"

				cabal2nix
				cabal-install
				ghc

				nodejs
				nodePackages.nodemon

				#mongodb-4_2
				mongodb
			];

			#pythonPackages = with pkgs."${pythonVersion}Packages"; [
			pythonPackages = packages: with packages; [
				#bpython
				numpy
				pyglet
				cython
				pynvim
				tasklib
			];
			haskellPackages = with pkgs.haskellPackages; [
				haskell-language-server
				hoogle
				ghcid

				vector
                #ghc-vis
			];

			swayPackages = with pkgs; [
				swayidle # Customise idle behaviour
				##swaylock # Lock screen
				swaylock-effects # Various fancy effects
				#unstable.waybar # Info bar
				grim # Take screenshot
				slurp # Select area on screen
				#mako # Notifications
				wl-clipboard # Pipe: copy to clipboard
				kanshi
				xdg-desktop-portal-wlr
				dmenu # Simple fuzzy item selection
				wofi # Wayland rofi, dmenu alternative
				wob # Show progress bar
				flashfocus
				evemu
				libinput
				libappindicator
				brightnessctl
			];
		in cliMiscPackages
		++ guiMiscPackages
		++ programmingPackages
		++ haskellPackages
		++ swayPackages
		++ [(python38.withPackages pythonPackages)]
	;

	programs.bat.enable = true;

	programs.neovim = {
		enable = true;
		vimAlias = true;
		withPython3 = true;
		extraConfig = readConfig /nvim/init.vim;
		plugins =
			let ctrlsf-vim = pkgs.vimUtils.buildVimPluginFrom2Nix {
				name = "ctrlsf-vim";
				src = pkgs.fetchFromGitHub {
					owner = "dyng";
					repo = "ctrlsf.vim";
					rev = "51c5b285146f042bd2015278f9b8ad74ae915e00";
					sha256 = "1901cr6sbaa8js4ylirz9p4m0r9q0a06gm71ghl6kp6pw7h5fgmq";
				};
			};
			vim-lf = pkgs.vimUtils.buildVimPluginFrom2Nix {
				name = "vim-lf";
				src = pkgs.fetchFromGitHub {
					owner = "longkey1";
					repo = "vim-lf";
					rev = "558634097fe02abd025100158c20277618b8bab2";
					sha256 = "06f3lz4dkslnhysl0jcykm4b2pnkazjjpafnxlhz4qsrf21jqkfm";
				};
			};
			in
			with pkgs.vimPlugins; [
				# Aesthetics
				gruvbox # Nice colour scheme
				#vim-airline # Line at bottom of screen
				#vim-airline-themes

				#nvim-treesitter # Better syntax hightlighting

				#vim-bufferline
        	    #nvim-bufferline-lua
				#barbar-nvim # Better tabs
				nvim-web-devicons

				vim-smoothie # Smooth scrolling

				# Language support
				vim-nix
				vim-fish
                i3config-vim

				vim-markdown # md support

				coc-nvim
				coc-python
				coc-clangd
				coc-rls
				coc-css
				coc-html
				coc-tsserver
				coc-json
				coc-cmake
				coc-java

				# Utilities
				suda-vim # sudo, but without launching Vim with sudo
				#vim-maximizer # makes window fill screen
				auto-pairs # Pairs, adds spaces, newline support
				nvim-colorizer-lua # Highlights colour codes in cod
				vimsence # Discord rich presence
				vim-hoogle # Hoogle search within Vim
				emmet-vim # generate HTML (like zen coding)

				vimwiki # note-taking
				taskwiki
				vim-markdown

				# Movement
				vim-sneak
				ctrlp-vim
				ctrlsf-vim
				vim-floaterm
				lf-vim
				vim-lf
				fzf-vim
				
				# Git
				vim-signify
				vim-fugitive
				vim-rhubarb
				vim-gitbranch
			];
			extraPackages = with pkgs; [
				(python3.withPackages (ps: with ps; [
					pynvim
					tasklib
				]))
				nodejs
			];
			extraPython3Packages = (ps: with ps; [
				pynvim
				tasklib
			]);
       };
    	xdg.configFile."nvim/coc-settings.json".text = readConfig /nvim/coc-settings.json;

	xdg.mimeApps = {
		enable = true;
		defaultApplications = {
			"image/png" = "sxiv.desktop";
			"image/jpeg" = "sxiv.desktop";
			"image/gif" = "sxiv.desktop";

			"video/mp4" = "mpv.desktop";
			"x-scheme-handler/discord-424004941485572097"="discord-424004941485572097.desktop";
			"x-scheme-handler/postman" = "Postman.desktop";
		};
	};

	programs.mako = {
		# https://github.com/nix-community/home-manager/blob/master/modules/services/mako.nix
		enable = true;
		maxVisible = 5;
		sort = "+time";
		anchor = "bottom-right";
		font = pangoFont 10;
		backgroundColor = "#" + gruvboxTheme.bg + "CC";
		borderRadius = 2;
		borderColor = "#" + gruvboxTheme.yellow;
		defaultTimeout = 5000;
	};

	wayland.windowManager.sway = {
		enable = true;
		wrapperFeatures.gtk = true;
		config = rec {
			#fonts = {"${defaultFont}" = 15;} ;
			#fonts = { "FiraCode" = 15; };
			floating.criteria = [
				{"app_id" = "nm-connection-editor";}
				{"app_id" = "pavucontrol";}
			];
			input."*" = {
				xkb_layout = "gb";
				accel_profile = "flat";
				pointer_accel = "-0.5";
			};
			output."*".bg = "${homeConfigDir}/sway/backgrounds/gruvbox-dark-rainbow.png fill";
			terminal = defaultTerminal;
			modifier = "Mod4";
			#menu = "dmenu_path | wofi -i --show run --gtk-dark | xargs swaymsg exec --";
			menu = "fish -c $(echo \"$(fish -c functions)\\n$(dmenu_path)\" | tr -s ', ' '\\n' | wofi -i --show dmenu --gtk-dark)";
			bars = [
				{
					position = "top";
					command = "${pkgs.waybar}/bin/waybar";
				}
			];
			gaps = {
				inner = 10;
				outer =  0;
			};
			window.border = 2;

			keybindings = with config.wayland.windowManager.sway.config; {
				"${modifier}+Return" = "exec -- $(${homeConfigDir}/sway/scripts/open-terminal-cd.bash 'foot -D')"; # If alacritty, use '${terminal} -e'
				"Ctrl+Mod1+t" = "exec ${terminal}"; # Gnome default
				"${modifier}+d" = "exec ${menu}";
				"${modifier}+w" = "exec epiphany";
				"${modifier}+Shift+q" = "kill";

				"${modifier}+${up}" = "focus up";
				"${modifier}+${down}" = "focus down";
				"${modifier}+${left}" = "focus left";
				"${modifier}+${right}" = "focus right";
			
				"${modifier}+Up" = "focus up";
				"${modifier}+Down" = "focus down";
				"${modifier}+Left" = "focus left";
				"${modifier}+Right" = "focus right";
			
				"${modifier}+Shift+${up}" = "move up";
				"${modifier}+Shift+${down}" = "move down";
				"${modifier}+Shift+${left}" = "move left";
				"${modifier}+Shift+${right}" = "move right";
			
				"${modifier}+Shift+Up" = "move up";
				"${modifier}+Shift+Down" = "move down";
				"${modifier}+Shift+Left" = "move left";
				"${modifier}+Shift+Right" = "move right";

				"${modifier}+b" = "splith";
				"${modifier}+v" = "splitv";

				"${modifier}+1" = "workspace number 1";
				"${modifier}+2" = "workspace number 2";
				"${modifier}+3" = "workspace number 3";
				"${modifier}+4" = "workspace number 4";
				"${modifier}+5" = "workspace number 5";
				"${modifier}+6" = "workspace number 6";
				"${modifier}+7" = "workspace number 7";
				"${modifier}+8" = "workspace number 8";
				"${modifier}+9" = "workspace number 9";
				"${modifier}+0" = "workspace number 10";
			
				"${modifier}+Shift+1" = "move container to workspace number 1";
				"${modifier}+Shift+2" = "move container to workspace number 2";
				"${modifier}+Shift+3" = "move container to workspace number 3";
				"${modifier}+Shift+4" = "move container to workspace number 4";
				"${modifier}+Shift+5" = "move container to workspace number 5";
				"${modifier}+Shift+6" = "move container to workspace number 6";
				"${modifier}+Shift+7" = "move container to workspace number 7";
				"${modifier}+Shift+8" = "move container to workspace number 8";
				"${modifier}+Shift+9" = "move container to workspace number 9";
				"${modifier}+Shift+0" = "move container to workspace number 10";

				"Ctrl+${modifier}+Left" = "workspace prev";
				"Ctrl+${modifier}+Right" = "workspace next";

				"Ctrl+${modifier}+${left}" = "workspace prev";
				"Ctrl+${modifier}+${right}" = "workspace next";

				"${modifier}+Shift+Space" = "floating toggle";
				"${modifier}+Space" = "focus_mode toggle";
				"${modifier}+f" = "fullscreen toggle";
				"${modifier}+n" = "exec flashfocus";
				"XF86AudioRaiseVolume" = "exec amixer -q set Master 5%+ unmute && amixer sget Master | grep 'Right:' | awk -F'[][]' '{ print substr($2, 0, length($2)-1) }' > /tmp/wobpipe";
				"XF86AudioLowerVolume" = "exec amixer -q set Master 5%- unmute && amixer sget Master | grep 'Right:' | awk -F'[][]' '{ print substr($2, 0, length($2)-1) }' > /tmp/wobpipe";
				"XF86AudioMute" = "amixer sset Master toggle | sed -En '/\\[on\\]/ s/.*\\[([0-9]+)%\\].*/\\1/ p; /\\[off\\]/ s/.*/0/p' | head -1 > /tmp/wobpipe";
				"XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
				"XF86MonBrightnessUp" = "exec brightnessctl set 5%+";
				"Print" = "exec grim - | wl-copy";
				"${modifier}+Print" = "exec grim -g \"$(slurp)\" - | wl-copy";
			};

			colors = rec {
				unfocused = {
					text = "#" + gruvboxTheme.red;
					border = "#" + gruvboxTheme.red;
					background = "#" + gruvboxTheme.red;

					indicator = "#" + gruvboxTheme.gray;
					childBorder = "#" + gruvboxTheme.gray;
				};
				focusedInactive = unfocused;
				urgent = unfocused // {
					indicator = "#" + gruvboxTheme.orange;
					childBorder = "#" + gruvboxTheme.orange;
				};
				focused = unfocused // {
					indicator = "#" + gruvboxTheme.yellow;
					childBorder = "#" +  gruvboxTheme.yellow;
				};
			};
		};

		# swaymsg -t get_inputs
		extraConfig = readConfig /sway/config;
	};

	programs.waybar = {
		enable = true;
    };
	xdg.configFile."waybar/config".text = readConfig /waybar/config;
	xdg.configFile."waybar/style.css".text = readConfig /waybar/style.css;
	xdg.configFile."waybar/colours.css".text = readConfig /waybar/colours.css;

	programs.alacritty = {
		enable = true;
	};
	xdg.configFile."alacritty/alacritty.yml".text = readConfig /alacritty/themes/gruvbox-material-alacritty.yml;

	programs.foot = {
		enable = true;
		settings = {
			main = {
				term = "foot";
				font = "monospace:size=11";
				dpi-aware = "yes";
				#letter-spacing="1";
			};
			colors = {
				background = "282828";
				foreground = "ebdbb2";
				regular0 = "282828";
				regular1 = "cc241d";
				regular2 = "98971a";
				regular3 = "d79921";
				regular4 = "458588";
				regular5 = "b16286";
				regular6 = "689d6a";
				regular7 = "a89984";
				bright0 = "928374";
				bright1 = "fb4934";
				bright2 = "b8bb26";
				bright3 = "fabd2f";
				bright4 = "83a598";
				bright5 = "d3869b";
				bright6 = "8ec07c";
				bright7 = "ebdbb2";
			};
		};
	};

	programs.fish = {
		enable = true;
		shellInit = readConfig /fish/icons.fish;
		shellAliases = {
			exe = "result/bin/*";
			ls = "lsd";
			nix-pr = "/nix/var/nix/profiles/system";
			avg-core-temp = "cat /sys/class/thermal/thermal_zone*/temp | awk '{ sum += $1 } END { print sum / NR }'";
		};
		functions = {
			project-new = {
				description = "Creates a new project in dump and link to current location";
				body = ''
					set link_path (pwd)
					set project_path "${devDir}/.dump/projects/$argv[1]"
					mkdir $project_path
					ln -s $project_path $name
					cd $project_path
                    "$link_path/.gen.fish" $link_path
				'';
#					printf "%s\n" \
#						"with import <nixpkgs> { };" \
#						"mkShell {" \
#						"	buildInputs = [ $argv[2..-1] ];" \
#						"}" > $project_path/shell.nix
			};
			project-del = {
				description = "Deletes project in dump and deletes link in current directory";
				body = ''
					for name in $argv
						rm -r $project_path "${devDir}/.dump/projects/$name"
						rm $name
					end
				'';
			};
			project-list-all = {
				description = "Lists all projects in dump";
				body = ''
					ls ${devDir}/.dump/projects
				'';
			};
			__informative_git_prompt = {
				description = "Provides git information";
				body = readConfig /fish/functions/__informative_git_prompt.fish;
			};

			pkg-search = {
				description = "Search for Nix package";
				body = ''
					nix-env -f '<nixpkgs>' -qaP -A $argv
				'';
			};

			gparted-run = {
				description = "Run gparted";
				body = ''
					xhost +local:
					gparted
				'';
			};
			kdenlive-run = {
				description = "Run kdenlive on Wayland";
				body = ''
					QT_QPA_PLATFORM=xcb kdenlive
				'';
			};
		};
	};
	#xdg.configFile."fish/functions/__informative_git_prompt.fish".text = readConfig /fish/functions/__informative_git_prompt.fish;
	xdg.configFile."fish/functions/fish_prompt.fish".text = ''
		. ${homeConfigDir}/fish/functions/__informative_git_prompt.fish
		${readConfig /fish/functions/fish_prompt.fish};
	'';

	xdg.configFile."lf/lfrc".text = readConfig /lf/lfrc;

	programs.git = {
		enable = true;
		userName = "pseud0n";
		userEmail = "pseud0n@users.noreply.github.com";
        # SSH key stored locally
	};
	
#	programs.firefox = {
#		enable = true;
#		extensions = with pkgs.nur.repos.rycee.firefox-addons; [
#			privacy-badger
#			https-everywhere
#		];
#		profiles.default = {
#			id = 0;
#			settings = {
#				"browser.search.defaultenginename" = "Ecosia";
#				"font.name.monospace.x-western" = "FiraCode Nerd Font Mono";
#			};
#		};
#	};

	home.stateVersion = "21.05";
}
