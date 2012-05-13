#!/usr/bin/perl

use strict;
require "../lib/bgoffice_util_module.pm";



if ($ARGV[0] eq "--help") {
	print <<EOHelp;

Този скрипт печата на стандартния изход (главните) думи.

EOHelp

	exit;
}



my $file_name = "";

while ($file_name = next_file($file_name)) {

	my @w = get_words($file_name);

	for (@w) {
		print "$_\n";
	}

}

