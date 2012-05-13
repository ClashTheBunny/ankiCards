#!/usr/bin/perl

use strict;
require "../lib/bgoffice_util_module.pm";



if ($ARGV[0] eq "--help") {
	print <<EOHelp;

Този скрипт, чете данните генерирани от предната стъпка от
стандартния вход и премахва повторенията на едни и същи думи
но с различни суфикси.
Един пример:
беля/D     съществителното беля - пакост
беля/Y     глагола         беля - обелвам нещо
Се конвертира до:
беля/DY

Данните се печатат на стандартния изход. След това файлът е
готов за работа и не трябва да се сортира. Единственото, което
трябва да се направи е да се запише броя на думите на първият
ред на файла.

EOHelp

	exit;
}

my @data = <STDIN>;
chop(@data);

my $buffer = "";
my $w = "";
my $oldw = "";
my $sfx = "";

for (@data) {
	my $p = index($_, "/");
	if ($p > 0) {
		$w = substr($_, 0, $p);
		$sfx = substr($_, $p + 1, 1);
	} else {
		$w = $_;
		$sfx = "";
	}
	if ($w eq $oldw) {
		$buffer .= $sfx;
	} else {
		if (length($buffer) > 0) {
			print "/$buffer";
		}
		print "\n$w";
		$buffer = $sfx;
	}
	$oldw = $w;
}

# Do not forget to flush buffer
if (length($buffer) > 0) {
	print "/$buffer";
}

print "\n";
