#!/usr/bin/perl

use strict;
require "../lib/bgoffice_util_module.pm";



if ($ARGV[0] eq "--help") {
	print <<EOHelp;

“ози скрипт печата всички описани€ едно след друго,
като постав€ разделител между различните описани€.
—поред терминологи€та това са частите на речта.


EOHelp

	exit;
}



my $file_name = "";
my $grp = "";

while ($file_name = next_file($file_name)) {

	if ($grp ne get_group($file_name)) {
		$grp = get_group($file_name);

		print "# $grp\n";

		my @w = get_forms($file_name);
		for (@w) {
			print "$_\n";
		}
	}

}
