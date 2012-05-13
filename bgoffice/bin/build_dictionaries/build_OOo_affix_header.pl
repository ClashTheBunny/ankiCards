#!/usr/bin/perl

use strict;
require "../lib/bgoffice_util_module.pm";



if ($ARGV[0] eq "--help") {
	print <<EOHelp;

Този скрипт генерира заглавната (header) част на OpenOffice.org
афикс файла (bg_BG.aff).

Справка в спецификацията на OpenOffice.org:
The second line specifies the characters to be used in building
suggestions for misspelled words. The should be listed in order
or character frequency (highest to lowest). A good way to
develop this string is to sort a simple character count of the
wordlist.

Т.е. скрипта брои честотата на използване на буквите. След това
ги отпечатва според честотата на използване, като най-често
срещаните букви се печатат първи.

EOHelp

	exit;
}



my $file_name = "";
my @t = ();

while ($file_name = next_file($file_name)) {
	my @w = get_words($file_name);
	for (@w) {
		my $l = length($_);
		for (my $i = 0; $i < length($_); $i++) {
			my $c = substr($_, $i, 1);
			if (($c ge "а") && ($c le "я")) {
				$t[ord($c) - ord("а")]++;
			} elsif (($c ge "А") && ($c le "Я")) {
				$t[ord($c) - ord("А")]++;
			} else {
				print "Грешка в $file_name елемент <$_>.\n"
				    . "Секцията <Думи> съдържа елемент, който съдържа букви извън интервала А-я.\n";
	   			die;
			}
		}
	}
}

# print header
print "SET microsoft-cp1251\n";
print "TRY ";

# Here is a tricky part, be careful.

my $tt = 0;
my $max = 10000000;
my $lo_case = "";
my $up_case = "";

for (my $i = 0; $i <= $#t; $i++) {
	my $curmax = -1;
	for (my $j = 0; $j <= $#t; $j++) {
		if (($curmax < $t[$j]) && ($t[$j] < $max)) {
			$curmax = $t[$j];
		}
	}
	$max = $curmax;
	for (my $j = 0; $j <= $#t; $j++) {
		if (($curmax == $t[$j]) && ($curmax > 0)) {
			$lo_case .= chr(ord("а") + $j);
			$up_case .= chr(ord("А") + $j);
		}
	}
	$tt += $t[$i];
}

# Just for the record!
# print "total number of chars: $tt\n";

print $lo_case . $up_case . "\n\n";
