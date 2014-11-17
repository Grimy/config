#!/usr/bin/perl -w
use strict;

chomp(my $base = `readlink -f ~/.vim`);
for my $dir ('', <bundle/*>) {
	chdir "$base/$dir";
	`git ls-remote --get-url origin` =~ /Grimy/ || next;
	$_ = `git status --porcelain; git diff --name-only -t HEAD..origin/master`;
	$_ && print "\t", $dir || 'vimfiles', "\n$_";
}
