#!/usr/bin/perl

use strict;
require "../lib/bgoffice_util_module.pm";



if ($ARGV[0] eq "--help") {
	print <<EOHelp;

Този скрипт печата всички думи във формат "дума тип". След
това думите се сортират и се пускат през друг скрипт, който
филтрира само еднаквите думи и ги отпечатва заедно с типа.

EOHelp

	exit;
}



my $file_name = "";
my $num = "";

while ($file_name = next_file($file_name)) {

	if ($file_name =~ /bg\d\d\d\.dat$/) {
		$num = substr($file_name, -7, 3);
	} else {
		$num = substr($file_name, -8, 4);
	}

	my @w = get_words($file_name);
	for (@w) {
		print "$_ $num\n";
	}

}
