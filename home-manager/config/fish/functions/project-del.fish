function project-del -d "Delete project"
	for name in $argv
		rm -r $project_path "$HOME/dev/.dump/projects/$name"
		rm $name
	end
end
