function project-new -d "Create a new project in dump and link to current location"
	set project_path "$HOME/dev/.dump/projects/$argv[1]"
	mkdir $project_path
	ln -s $project_path $name
	cd $project_path
	printf "%s\n" \
		"with import <nixpkgs> { };" \
		"mkShell {" \
		"	buildInputs = [ $argv[2..-1] ];" \
		"}" > $project_path/shell.nix
end


