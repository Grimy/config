function sm
	cd /mnt >/dev/null
	mkdir -p $argv
	sudo umount $argv
	sshfs -oworkaround=rename root@$argv:/ $argv
	cd $argv
end
