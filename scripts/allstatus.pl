#!/usr/bin/perl

my $base = '~/.vim';
chdir $base;

for my $dir ('', <bundle/*>) {
	chdir "$base/$dir";
	`git ls-remote --get-url origin` =~ /Grimy/ || next;
	$_ = `git status --porcelain; git diff --name-only -t HEAD..origin/master`;
	$_ && print "\t", $dir || 'vimfiles', "\n$_";
}
