function s
	cd ~/mnt
	sudo umount $argv
	mkdir -p $argv
	sshfs -oworkaround=rename root@$argv:/ $argv
	v $argv
	ssh root@$argv
end
