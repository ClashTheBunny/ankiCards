#!/usr/bin/perl

use strict;
require "../lib/bgoffice_util_module.pm";



if ($ARGV[0] eq "--help") {
	print <<EOHelp;

Този скрипт прави същото като скрипта, който генерира данните
за aspell с разликата, че го прави само за файловете, които
се намират в affix_info.dat файла. След това данните трябва
да бъдат сортирани и да се премахнат ограниченията.

EOHelp

	exit;
}



my $file_name = "";
my $num = "";

while ($file_name = next_file($file_name)) {

	if ($file_name =~ /bg\d\d\d\.dat$/) {
		$num = substr($file_name, -9, 9);
	} else {
		$num = substr($file_name, -10, 10);
	}

	my $affix = `grep $num affix_info.dat`;
	chop($affix);

	if ($affix) {

		my @e = get_endings($file_name);
		my @w = get_words($file_name);

		for (@w) {
			my @gen = build_forms($_, @e);
			for (@gen) {
				if ($_ ne "-") {
					my @sp = split(/,/, $_);
					for (@sp) {
						print "$_\n";
					}
				}
			}
		}

	}

}
