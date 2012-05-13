#!/usr/bin/perl

use strict;
require "../lib/bgoffice_util_module.pm";



if ($ARGV[0] eq "--help") {
	print <<EOHelp;

Този скрипт генерира речника за aspell. Вземат се думите и се
прилагат окончанията и данните се печатат на стандартния изход.
След това думите трябва да бъдат сортирани и повторенията трябва
да бъдат премахнати. Т.е. да се пуснат през sort и uniq.

Може да се ползва с:
--before187 за типовете от 1 до 187
--after187 за типовете след 187.
Без параметри се генерира за всички типове.

EOHelp

	exit;
}



my $file_name = "";
my $num = 0;

while ($file_name = next_file($file_name)) {

	if ($file_name =~ /bg\d\d\d\.dat$/) {
		$num = substr($file_name, -7, 3);
	} else {
		$num = substr($file_name, -8, 3);
	}

	if (($ARGV[0] eq "--before187") && ($num > 187)) {
		last;
	}
	if (($ARGV[0] eq "--after187") && ($num < 188)) {
		next;
	}

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
