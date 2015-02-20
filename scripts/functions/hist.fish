function hist
	perl -ple '++$_{v9,/^- cmd: (\S+)/}}for(keys%_){s]^]$_{$_}]' ~/.config/fish/fish_history | sort -nr | head $argv
end
