#!/usr/bin/perl

use strict;
require "../lib/bgoffice_util_module.pm";



if ($ARGV[0] eq "--help") {
	print <<EOHelp;

Този скрипт проверява дали броя на окончанията зададен във
всеки файл отговаря на броя на формите зададени във файла
с описанието в същата директория.

EOHelp

	exit;
}


my $verbose = ($ARGV[0] eq "--verbose");


my $file_name = "";

while ($file_name = next_file($file_name)) {

	print "Checking $file_name ...\n" if $verbose;

	my @e = get_endings($file_name);
	my @f = get_forms($file_name);

	if ($#f != $#e) {
		print "Грешка в $file_name.\n"
		    . "Секцията <Окончания> съдържа $#e елемента, а трябва да съдържа $#f.\n\n";
	}

}
