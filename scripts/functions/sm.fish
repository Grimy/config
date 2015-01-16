function sm
	cd /mnt >/dev/null
	mkdir -p $argv
	sudo umount $argv
	sshfs -oworkaround=rename root@$argv{:/,}
	cd $argv
end
