function chrysalis
	while read -p 'echo -ne "\e[32mChrysalis\e[m> "' command
		for forge in hep edf rte snj ems
			echo -e "\n\e[32m==========> $forge <==========\e[m\n"
			ssh -n "$forge" $command
			echo -ne "\n"
		end
	end
end
