function ns -d "Creates nix-shell enviroment"
	nix-shell "$HOME/dev/.dump/.nix/$argv.nix" --run fish
end
