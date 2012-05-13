#!/usr/bin/perl

use strict;
require "../lib/bgoffice_util_module.pm";



if ($ARGV[0] eq "--help") {
	print <<EOHelp;

Този скрипт е подобен на скрипта за генериране на речника
за aspell.
Скриптът чете от стандартния вход файла с основните думи
и определя позицията на основната дума за всяка слофоворма.
За целта файла с основните думи не трябва да бъде в двоичен
формат.


EOHelp

	exit;
}

my @data = <STDIN>;
chop(@data);

my @wrd = ();

for(@data) {
	my @line = split(/ /, $_);
	push(@wrd, $line[0]);
}


my $file_name = "";
my $c = 0;

while ($file_name = next_file($file_name)) {

	$c++;
	my @e = get_endings($file_name);
	my @w = get_words($file_name);

	for (@w) {
		my $sm = $_;
		my $c = substr($sm, 0, 1);
		if (($c ge "А") && ($c le "Я")) {
			$sm = chr(ord($c) + 32) . substr($sm, 1);
		}
		my $ww = search_in_data($sm) + 1;
		if ($ww < 1) {
			die "missing base word <$sm>\n";
		}
		my @gen = build_forms($_, @e);
		for (@gen) {
			if ($_ ne "-") {
				my @sp = split(/,/, $_);
				for (@sp) {
					print "$_ $ww\n";
				}
			}
		}
	}

}


sub search_in_data() {
	my $w = @_[0];
	my $b = 0;
	my $e = $#wrd;
	my $m = 0;
	while (1) {
		if ($b > $e) {
			return -1;
		}
		$m = int(($b + $e) / 2);
		if ($w gt $wrd[$m]) {
			$b = $m + 1;
		} elsif ($w lt $wrd[$m]) {
			$e = $m - 1;
		} else {
			return $m;
		}
	}
}
