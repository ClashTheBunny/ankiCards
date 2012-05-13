#!/usr/bin/perl

use strict;
require "../lib/bgoffice_util_module.pm";



if ($ARGV[0] eq "--help") {
	print <<EOHelp;

Този скрипт конвертира affix_info.dat файла от формат:
[име на файл], [число от 1 до 26]
до формат:
[голяма латинска буква]  [име на файл]

Пример:
../../data/adjective/bg079.dat, 1
се конвертира до
A ../../data/adjective/bg079.dat

Данните се четат от стандартния вход и се печатат на
стандартния изход. Изходният файл може да бъде сортиран
с цел по-лесно търсене на информацията.

EOHelp

	exit;
}



my @data = <STDIN>;
chop(@data);

for (@data) {
	my $line = strip_line($_);
	if ($line) {
		my $ind = index($line, ",");
		if ($ind < 0) {
			die "No space delimiter in line <$line>.\n";
		}
		my $ch = substr($line, $ind + 1);
		my $letter = chr(ord("A") + $ch - 1);
		if ($letter !~ /[A-Z]/) {
			die "Charater <$letter> is not allowed in line <$line>.\n";
		}
		print $letter, " ", substr($line, 0, $ind);
	}
	print "\n";

}
