function lyra
	cd ~/Music
	find . -name '*.mp3' -or -name '*.wma ' -or -name '*.flac' -or -name '*.m4a' -or -name '*.wav' >playlist
	rm /tmp/mplayer.fifo
	mkfifo /tmp/mplayer.fifo
	ponysay -oqlyra
	mplayer -shuffle -playlist playlist -idle -slave -input file=/tmp/mplayer.fifo
end
