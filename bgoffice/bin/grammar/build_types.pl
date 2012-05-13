#!/usr/bin/perl

use strict;
require "../lib/bgoffice_util_module.pm";



if ($ARGV[0] eq "--help") {
	print <<EOHelp;

Този скрипт печата всички типове един след друг, като
поставя разделител между различните групи. Скриптът
печата и номера на групата и описанието и.


EOHelp

	exit;
}



my $file_name = "";
my $d = 0;
my $grp = "";

while ($file_name = next_file($file_name)) {

	if ($grp ne get_group($file_name)) {
		$d++;
		$grp = get_group($file_name);
	}

	print "# $d\n";

	my @w = get_endings($file_name);
	my $f = get_filter($file_name);
	for (@w) {
		if ($_ =~ /(.*)\[(.+)\](.*)/) {
			print "$1?$3";
		} else {
			print "$_";
		}
		if ($f ne "") {
			print ":$f";
			$f = "";
		}
		print "\n";
	}

}
