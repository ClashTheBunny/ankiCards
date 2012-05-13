#!/usr/bin/perl

use strict;
require "../lib/bgoffice_util_module.pm";



if ($ARGV[0] eq "--help") {
	print <<EOHelp;

Този скрипт печата всички думи, които имат представки
във формат "тип дума представки". След това думите могат
да бъдат обработвани по различен начин.

EOHelp

	exit;
}



my $file_name = "";
my $num = "";

while ($file_name = next_file($file_name)) {

	if ($file_name =~ /bg\d\d\d\.dat$/) {
		$num = substr($file_name, -7, 3);
		$num .= " ";
	} else {
		$num = substr($file_name, -8, 4);
	}

	open(IN, "<$file_name") || die "Cannot open $file_name";
	my @d;
	@d = <IN>;
	close(IN);
	chop(@d);
	my $r = 0;
	for (@d) {
		if ($r == 0) {
			$r = (strip_line($_) eq "Думи:");
		} elsif (index($_, " ") > 0) {
			print "$num  $_\n";
		}
	}

}
