#!/usr/bin/perl

use strict;
require "../lib/bgoffice_util_module.pm";



if ($ARGV[0] eq "--help") {
	print <<EOHelp;

Този скрипт печата всички описания едно след друго,
като поставя разделител между различните описания.
Според терминологията това са частите на речта.


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
