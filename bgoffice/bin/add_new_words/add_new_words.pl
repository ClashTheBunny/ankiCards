#!/usr/bin/perl

use strict;
require "../lib/bgoffice_util_module.pm";



if ($ARGV[0] eq "--help") {
	print <<EOHelp;

Този скрипт чете данни от стандартния вход във формат
[дума] [файл] и ги добавя в съответния файл.

Пример:
ясла   ../../data/noun/female/bg041.dat
мрянка   ../../data/noun/female/bg043a.dat
мяра   ../../data/noun/female/bg043.dat
мярка   ../../data/noun/female/bg043a.dat

Идеята е след като се генерират предложения за думите,
файлът с резултата да бъде прегледан и от него да се
изтрият грешните предложения. По този начин във файлът
ще останат само верните предложения и скрипта ще добави
думите в правилните типове (файлове).

Думите се добавят на края на файла и не се вземат предвид
съществуващите представки. За да се компресират данните до
варианта с представките използвайте съответния скрипт.

EOHelp

	exit;
}



# Load words
my @data = <STDIN>;
chop(@data);

for my $line (@data) {
	my $i = index($line, " ");
	my $word = strip_line(substr($line, 0, $i));
	my $file_name = strip_line(substr($line, $i));

	open(OUT, ">>$file_name") || die "Cannot open $file_name";
	print OUT "$word\n";
	close(OUT);

}
