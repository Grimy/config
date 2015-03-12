function cd --description 'Change directory'
	
	# Skip history in subshells
	if status --is-command-substitution
		builtin cd $argv
		return $status
	end

	# Avoid set completions
	set -l previous $PWD

	if test $argv[1] = - ^/dev/null
		if test "$__fish_cd_direction" = next ^/dev/null
			nextd
		else
			prevd
		end
		return $status
	end

	if test -f $argv[1]
		set argv (dirname $argv[1])
	end

	builtin cd $argv[1]
	set -l cd_status $status

	if test $cd_status = 0 -a "$PWD" != "$previous"
		set -g dirprev $dirprev $previous
		set -e dirnext
		set -g __fish_cd_direction prev
		ls -lAh
	end

	return $cd_status
end
