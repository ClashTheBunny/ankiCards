#!/usr/bin/perl

use strict;
require "../lib/bgoffice_util_module.pm";



if ($ARGV[0] eq "--help") {
	print <<EOHelp;


Този скрипт приема данните генерирани от стъпка 1. Преди това
тези данни трябва да бъдат сортирани и да бъдат премахнати
повторенията (sort, uniq). Скрипта брои данните за една секция
и печата заглавната част на секцията.

Справка в спецификацията на OpenOffice.org. Форматът е следния:
SFX [letter] [Y or N] [number of affixes]
letter            = числото от affix_info.dat превърнато в буква
                    или буквата от конкретната секция.
Y or N            = дали може да се комбинира с префикс. Понеже
                    нямаме префикси винаги е Yes. Може и No.
number of affixes = броя на редовете след този ред (броя на
                    елементите в тази секция, която се определя
                    по буквата).

За нагледност се вкарват допълнителни интервали. Един пример:
SFX A Y 15

EOHelp

	exit;
}


my @data = <STDIN>;
chop(@data);

my $sfx = "";
my $oldsfx = "";
my @buffer = ();

for (@data) {
	$sfx = substr($_, 0, 5);
	if ($sfx ne $oldsfx) {
		if ($#buffer > 0) {
			my $n = $#buffer + 1;
			print "$oldsfx Y $n\n";
			for (@buffer) {
				print "$_\n";
			}
			print "\n";
		}
		$oldsfx = $sfx;
		@buffer = ();
	}
	push(@buffer, $_);
}

# Do not forget to flush buffer
if ($#buffer > 0) {
	my $n = $#buffer + 1;
	print "$oldsfx Y $n\n";
	for (@buffer) {
		print "$_\n";
	}
}
