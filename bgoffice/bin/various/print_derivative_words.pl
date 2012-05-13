#!/usr/bin/perl

use strict;
require "../lib/bgoffice_util_module.pm";



if ($ARGV[0] eq "--help") {
	print <<EOHelp;

Този скрипт печата на стандартния изход словоформите. Вземат
се думите и се прилагат окончанията и данните се печатат на 
стандартния изход.

EOHelp

	exit;
}



my $file_name = "";

while ($file_name = next_file($file_name)) {

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

