#!/usr/bin/perl

use strict;
require "../lib/bgoffice_util_module.pm";



if ($ARGV[0] eq "--help") {
	print <<EOHelp;

Този скрипт проверява думите дали отговарят на филтъра. Филтърът е
първия ред от секцията окончания.

Справка в спецификацията:
- Филтърът (първият ред от секцията окончания) може да бъде "0" или
  поредица от малки букви и да съдържа до един клас от малки букви
  (клас според спецификацията на регулярните изрази). "0" означава,
  че няма филтър.

EOHelp

	exit;
}

my $verbose = ($ARGV[0] eq "--verbose");


my $file_name = "";

while ($file_name = next_file($file_name)) {

	print "Checking $file_name ...\n" if $verbose;

	my $f = get_filter($file_name);
	my @e = get_endings($file_name);
	my $o = $e[0];

	if (($f eq "0") && ($o eq "0")) {
		next;
	}

	my @w = get_words($file_name);
	for (@w) {
		my $c = $_;
		if ($c !~ /$f$/) {
			print "Грешка в $file_name елемент <$c>.\n"
			    . "Секцията <Думи> съдържа елемент, който не отговаря на филтъра.\n\n";
		}
		if (($f ne $o) && ($o ne "0") && ($c !~ /$o$/)) {
			print "Грешка в $file_name елемент <$c>.\n"
			    . "Секцията <Думи> съдържа елемент, който не отговаря на първото окончание.\n\n";
		}
	}

}
