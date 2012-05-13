#!/usr/bin/perl

use strict;
require "../lib/bgoffice_util_module.pm";



if ($ARGV[0] eq "--help") {
	print <<EOHelp;

Този скрипт печата информация за броя на думите, броя на
условията, броя на окончанията. Информацията се печата в
CSV формат, може да се обработва с електронна таблица и е
много полезна при създаването на affix_info.dat файла.

EOHelp

	exit;
}



my $file_name = "";
my $num = "";

print "Type, SubType, Words, Affixes, Total, Groups, Filter\n";

while ($file_name = next_file($file_name)) {

	my $type = "";
	if ($file_name =~ /bg\d\d\d\.dat$/) {
		$num = substr($file_name, -9, 9);
		$type = substr($file_name, 0, length($file_name) - 10);
	} else {
		$num = substr($file_name, -10, 10);
		$type = substr($file_name, 0, length($file_name) - 11);
	}

	my $ff = get_filter($file_name);
	my @e = get_endings($file_name);
	my $f = $e[0];
	my @w = get_words($file_name);
	my $words = $#w + 1;

	print "$type, $num, $words, ";

	my $aff = -1;
	for (@e) {
		if ($_ ne "-") {
			$aff++;
		}
	}
	print "$aff, ";

	my $total = $aff * $words;
	print "$total, ";

	if ($f =~ /(.*)\[(.+)\](.*)/) {
		my $c1 = $1;
		my $c2 = $2;
		my $c3 = $3;
		my $l1 = length($c1);
		my $l2 = length($c2);
		my $l3 = length($c3);
		for (my $j = 0; $j < $l2; $j++) {
			my $replace = substr($c2, $j, 1);
			print $c1 . $replace . $c3 . " ";
		}
		print ", ";
	} else {
		if ($f ne "0") {
			print "$f, ";
		} else {
			print "-, ";
		}
	}

	print "$ff\n";

}
