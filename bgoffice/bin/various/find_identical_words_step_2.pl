#!/usr/bin/perl

use strict;
require "../lib/bgoffice_util_module.pm";



if ($ARGV[0] eq "--help") {
	print <<EOHelp;

Този скрипт чете от стандартния вход думите с типа и отпечатва
еднаквите думи и типовете, в които се срещат.

EOHelp

	exit;
}


my @data = <STDIN>;
chop(@data);
my $p = 0;
my $w = "";
my $t = "";
my $oldw = "";
my $oldt = "";

for(@data) {
	my $p = index($_, " ");
	if ($p > 0) {
		$w = substr($_, 0, $p);
		$t = substr($_, $p + 1);
	} else {
		die "no space in line <$_>\n";
	}
	if ($w eq $oldw) {
		if ($oldt) {
			print "\n";
			print "$w $oldt $t";
		} else {
			print " $t";
		}
		$oldt = "";
	} else {
		$oldw = $w;
		$oldt = $t;
	}

}
print "\n";
