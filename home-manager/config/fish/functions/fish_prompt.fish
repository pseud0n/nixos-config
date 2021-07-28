set -g fish_prompt_git_status_conflicted '×'
set -g fish_prompt_git_status_changed '+'

function fish_prompt --description 'Write out the prompt'
    set laststatus $status

	set -l nix_shell_info (
	  if test -n "$IN_NIX_SHELL"
	    echo -n "❄︁"
	  end
	)

	set git_info (__informative_git_prompt)

	set info "$nix_shell_info" # if in nix shell
	if not test -z "$info"
		set info "$info"
		if not test -z "$git_info"
			set info "$info/$git_info"
		end
	else
		if not test -z "$git_info"
			set info "$git_info"
		end
	end

	if not test -z "$info"
		set info "$info " # add space if not empty string
	end

    set_color -b normal
    printf '%s%s%s%s' $last_status (set_color -o yellow) (prompt_pwd) (set_color -o blue) " $info" (set_color white)
    if test $laststatus -eq 0
        printf "%s" (set_color -o green)
    else
		printf "%s" (set_color -o red)
    end
	printf "● %s" (set_color normal)
end
