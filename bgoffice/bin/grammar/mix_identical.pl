#!/usr/bin/perl

use strict;
require "../lib/bgoffice_util_module.pm";



if ($ARGV[0] eq "--help") {
	print <<EOHelp;

Този скрипт чете от стандартния вход думите с типа и отпечатва
еднаквите думи и типовете, в които се срещат.

Скриптът е подобен на скрипта за откриване на идентичните думи.


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
my $buffer = "";

for(@data) {
	my $p = index($_, " ");
	if ($p > 0) {
		$w = strip_line(substr($_, 0, $p));
		$t = strip_line(substr($_, $p + 1));
	} else {
		die "no space in line <$_>\n";
	}
	if ($w eq $oldw) {
		$buffer .= " ";
		$buffer .= $t;
	} else {
		if (length($buffer) > 0) {
			print "$buffer";
		}
		print "\n$w";
		$buffer = " ";
		$buffer .= $t;
	}
	$oldw = $w;
}

# Do not forget to flush buffer
if (length($buffer) > 0) {
	print "$buffer";
}

print "\n";
