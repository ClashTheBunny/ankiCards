#!/usr/bin/perl

use strict;
require "../lib/bgoffice_util_module.pm";



if ($ARGV[0] eq "--help") {
	print <<EOHelp;

Този скрипт конвертира някои редове на афикс файла
по следния начин:
SFX K   а         ата      .
до
SFX K   а         ата      a

Точката на края се заменя със знака (знаците) от
третата позиция.

Данните се четат от стандартния вход и се печатат на
стандартния изход.

EOHelp

	exit;
}



my @data = <STDIN>;
chop(@data);

my $old_line = "";

for (@data) {
	my $line = $_;
	my $beg = substr($_, 0, 3);
	if ($beg eq "SET") {
		print "SET windows-1251\n";
		next;
	}
	if (($beg eq "MAP") || ($beg eq "REP")) {
		exit;
	}
	if (($_ eq "") && ($old_line eq "")) {
		next;
	}
	if ((length($line) == 29) && (substr($line, 28, 1) eq ".") && (substr($line, 8, 1) ne "0")) {
		print substr($line, 0, 28);
		print strip_line(substr($line, 8, 10));
		print "\n";
	} else {
		print "$_\n";
	}
	$old_line = $_;
}
