#  nix-channel --add https://github.com/nix-community/home-manager/archive/release-21.05.tar.gz home-manager
# nix-channel --update

{ config, pkgs, ... }:
with import <nixpkgs> { config = { allowUnfree = true; }; };

let
	nixosConfig = (import <nixpkgs/nixos> {}).config;

	homeConfigDir = /etc/nixos/home-manager/config;

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
	defaultTerminal = "alacritty";

	readConfig = path: builtins.readFile (homeConfigDir + path);

in rec {
	#imports = lib.attrValues nur-no-pkgs.repos.moredhel.hmModules.modules;

	#services.unison = {
	#	enable = true;
	#	profiles = {
	#		org = {
	#			src = "/home/moredhel/org";
	#      			dest = "/home/moredhel/org.backup";
	#      			extraArgs = "-batch -watch -ui text -repeat 60 -fat";
	#		};
	#	};
	#};
	
	nixpkgs.config.packageOverrides = pkgs: {
		nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
				inherit pkgs;
			};
      	};
	
	nixpkgs.config.allowUnfree = true;
	nixpkgs.config.allowBroken = true;
	#allowBrokenPredicate = pkg: builtins.elem (lib.getName pkg) [
	#	"ghc-vis"
	#];
	programs.home-manager.enable = true;

	home.username = "alexs";
	home.homeDirectory = "/home/${home.username}";

	home.sessionVariables = {
		MOZ_ENABLE_WAYLAND = 1;
		XDG_CURRENT_DESTKOP = "sway";
	};

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
				bat
				nix-prefetch-git
				grub2
				doas
				appimage-run
				lf
				neofetch
				pfetch
				ripgrep
				fd
				flatpak
				dragon-drop
				lsd
				htop
				hexyl
				jack1
				xboxdrv
				libxkbcommon
				sxiv
				xdg-utils
				libinput
				jq
                pkg-config
			];

			guiMiscPackages = with pkgs; [
				qtchan
				neovim-qt
				element-desktop
				libreoffice
				#firefox-wayland
				etcher
				discord
				zoom-us
				thunderbird
				agenda
				spotify
				blender mupdf
				plasma5Packages.kdenlive
				gimp
				virtualbox
				webcamoid
				alacritty
				conky
				wine
				libappindicator-gtk3
				pcmanfm
			];

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

				pkgs."${pythonVersion}"

				cabal2nix
				cabal-install
				ghc

				nodejs
				yarn
			];

			pythonPackages = with pkgs."${pythonVersion}Packages"; [
				bpython
				numpy
				pyglet
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
				waybar # Info bar
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
			];
		in cliMiscPackages
		++ guiMiscPackages
		++ programmingPackages
		++ pythonPackages
		++ haskellPackages
		++ swayPackages
	;

	programs.bat.enable = true;

	programs.neovim = {
		enable = true;
		vimAlias = true;
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
			}; in
			with pkgs.vimPlugins; [
				# Aesthetics
				gruvbox # Nice colour scheme
        	    vim-airline # Line at bottom of screen
				vim-airline-themes

				#vim-bufferline
        	    #nvim-bufferline-lua
				#barbar-nvim # Better tabs
                nvim-web-devicons

				vim-smoothie # Smooth scrolling

				# Language support
				vim-nix
				vim-fish

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

				# Utilities
				suda-vim # sudo, but without launching Vim with sudo
				#vim-maximizer # makes window fill screen
				auto-pairs # Pairs, adds spaces, newline support
				nvim-colorizer-lua # Highlights colour codes in cod
				vimsence # Discord rich presence
				vim-hoogle # Hoogle search within Vim
				emmet-vim # generate HTML (like zen coding)

				# Movement
				vim-sneak
				ctrlp-vim
				ctrlsf-vim
				vim-floaterm
				lf-vim
				fzf-vim
				
				# Git
				vim-signify
				vim-fugitive
				vim-rhubarb
				vim-gitbranch
			];
	};
    xdg.configFile."nvim/coc-settings.json".text = readConfig /nvim/coc-settings.json;

	xdg.mimeApps = {
		enable = true;
		defaultApplications = {
			"image/png" = "sxiv.desktop";
			"image/jpeg" = "sxiv.desktop";
			"image/gif" = "sxiv.desktop";
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
			input."*".xkb_layout = "gb";
			output."*".bg = "${homeConfigDir}/sway/backgrounds/gruvbox-dark-rainbow.png fill";
			terminal = defaultTerminal;
			modifier = "Mod4";
			menu = "dmenu_path | wofi -i --show run --gtk-dark | xargs swaymsg exec --";

			keybindings = with config.wayland.windowManager.sway.config; {
                #"${modifier}+Return" = "exec \"alacritty -e fish -C $(pwdx $(ps -ef | awk '$3 == pid { print $2 }' pid=$(swaymsg -t get_tree | jq '.. | select(.type?) | select(.focused==true).pid')) | awk '{ print $2 }') || alacritty\"";
				"${modifier}+Return" = "exec $(${homeConfigDir}/sway/scripts/open-terminal-cd.bash)";
				"Ctrl+Mod1+t" = "exec alacritty"; # Gnome default
				"${modifier}+d" = "exec ${menu}";
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

	programs.alacritty = {
		enable = true;
	};
	xdg.configFile."alacritty/alacritty.yml" = {
		text = readConfig /alacritty/themes/gruvbox-material-alacritty.yml;
	};

	programs.fish = {
		enable = true;
		shellInit = readConfig /fish/icons.fish;
		shellAliases = {
			ls = "lsd";
			tree = "lsd --tree";
			nix-pr = "/nix/var/nix/profiles/system";
		};
		functions = {
			open_terminal = {
				description = "Opens new terminal in pwd of focused terminal, or $HOME if no terminal focused";
				body = ''
					set process_match (ps -ef | awk '$3 == pid { print $2 }' pid=(swaymsg -t get_tree | jq '.. | select(.type?) | select(.focused==true).pid')) | awk '{ print $2 }'
				    if test -z $process_match
				        echo alacritty
				    else
				        echo "alacritty -e fish -C" (pwdx $process_match | awk '{ print $2 }')
				    end
				'';
			};
			project-new = {
				description = "Creates a new project in dump and link to current location";
				body = ''
					set project_path "$HOME/dev/.dump/projects/$argv[1]"
					mkdir $project_path
					ln -s $project_path $name
					cd $project_path
					printf "%s\n" \
						"with import <nixpkgs> { };" \
						"mkShell {" \
						"	buildInputs = [ $argv[2..-1] ];" \
						"}" > $project_path/shell.nix
				'';
			};
			project-del = {
				description = "Deletes project in dump and deletes link in current directory";
				body = ''
					for name in $argv
					rm -r $project_path "$HOME/dev/.dump/projects/$name"
					rm $name
	end
				'';
			};
			project-list-all = {
				description = "Lists all projects in dump";
				body = ''
					ls $HOME/dev/.dump/projects
				'';
			};
			__informative_git_prompt = {
				description = "Provides git information";
				body = readConfig /fish/functions/__informative_git_prompt.fish;
			};
		};
	};
	#xdg.configFile."fish/functions/__informative_git_prompt.fish".text = readConfig /fish/functions/__informative_git_prompt.fish;
	xdg.configFile."fish/functions/fish_prompt.fish".text = ''
		. ${homeConfigDir}/fish/functions/__informative_git_prompt.fish
		${readConfig /fish/functions/fish_prompt.fish};
	'';

	programs.git = {
		enable = true;
		userName = "pseud0n";
		userEmail = "pseud0n@users.noreply.github.com";
        # SSH key stored locally
	};
	
	programs.firefox = {
		enable = true;
		extensions = with pkgs.nur.repos.rycee.firefox-addons; [
			privacy-badger
			https-everywhere
		];
#		profiles.default = {
#			id = 0;
#			settings = {
#				"browser.search.defaultenginename" = "Ecosia";
#				"font.name.monospace.x-western" = "FiraCode Nerd Font Mono";
#			};
#		};
	};

	home.stateVersion = "21.05";
}
