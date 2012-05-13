#!/usr/bin/perl

use strict;
require "../lib/bgoffice_util_module.pm";



if ($ARGV[0] eq "--help") {
	print <<EOHelp;

Този скрипт проверява, дали използваните символи в различните
секции отговарят на условията.

Справка в спецификацията:
- Филтърът (първият ред от секцията окончания) може да бъде "0" или
  поредица от малки букви и да съдържа до един клас от малки букви
  (клас според спецификацията на регулярните изрази).
- Останалите окончания, могат да бъдат "0", "-" или малки букви и да
  съдържат "?" ако имаме клас във филтъра.
- Тест елементите могат да бъдат "-" или малки букви.
- Думите, могат да съдържат само малки букви до (включително) тип
  193 и от тип 194 до края първата буква трябва да бъде главна.
  Думите могат да имат представки разделени с интервал след края
  на думата.

Секциите окончания и тест, могат да съдържат повече от един елемент
на ред разделен със запетайка (",").

EOHelp

	exit;
}


my $verbose = ($ARGV[0] eq "--verbose");


my $file_name = "";
my $num = 0;

while ($file_name = next_file($file_name)) {

	print "Checking $file_name ...\n" if $verbose;

	if ($file_name =~ /bg\d\d\d[.]dat$/) {
		$num = substr($file_name, -7, 3);
	} else {
		$num = substr($file_name, -8, 3);
	}

	my @e = get_endings($file_name);

	# Check filter
	my $c = $e[0];
	my $l = length($c);
	my $has_class = 0;
	my $result = 0;
	if ($c eq "0") {
		$result = 1;
	} elsif ($c =~  /[а-я]{$l}/) {
		$result = 2;
	} elsif ($c =~ /(.*)\[(.+)\](.*)/) {
		$has_class = 1;
		my $c1 = $1;
		my $c2 = $2;
		my $c3 = $3;
		my $l1 = length($c1);
		my $l2 = length($c2);
		my $l3 = length($c3);
		if (($c1 =~  /[а-я]{$l1}/) && ($c2 =~  /[а-я]{$l2}/) && ($c3 =~  /[а-я]{$l3}/)) {
			$result = 3;
		}
	}
	if (($result == 0) || ($l == 0)) {
		print "Грешка в $file_name елемент <$c>.\n"
		    . "Секцията <Окончания> (<Филтър>) съдържа елемент, който не отговаря на правилата.\n\n";
	}

	# Check endigns
	my $i = 0;
	for (@e) {
		if ($i == 0) {
			$i++;
			next;
		}
		my @sp = split(/,/, $_);
		# Tricky part. If edns with , just add empty element.
		if ($_ =~ /,$/) {
			push(@sp, "");
		}
		for (@sp) {
			my $c = strip_line($_);
			my $l = length($c);
			my $result = 0;
			if ($c eq "0") {
				$result = 1;
			} elsif ($c eq "-") {
				$result = 4;
			} elsif (($has_class == 0) && ($c =~  /[а-я]{$l}/)) {
				$result = 2;
			} elsif ($has_class == 1) {
				if ($c =~ /(.*)\?(.*)/) {
					my $c1 = $1;
					my $c2 = $2;
					my $l1 = length($c1);
					my $l2 = length($c2);
					if (($c1 =~  /[а-я]{$l1}/) && ($c2 =~  /[а-я]{$l2}/)) {
						$result = 3;
					}
				} elsif ((($num == 145) || ($num == 18)) && ($c =~  /[а-я]{$l}/)) {
					# Some cases in 145 and 18a do not have ?
					$result = 3;
				}
			}
			if (($result == 0) || ($l == 0)) {
				print "Грешка в $file_name елемент <$c>.\n"
				    . "Секцията <Окончания> съдържа елемент, който не отговаря на правилата.\n\n";
			}
		}
	}

	# Check tests
	my @t = get_tests($file_name);
	for (@t) {
		my @sp = split(/,/, $_);
		# Tricky part. If edns with , just add empty element.
		if ($_ =~ /,$/) {
			push(@sp, "");
		}
		for (@sp) {
			my $c = strip_line($_);
			my $l = length($c);
			my $result = 0;
			if ($c eq "-") {
				$result = 4;
			} else {
				if ($num <= 193) {
					if ($c =~  /[а-я ]{$l}/) {
						$result = 1;
					}
				} else {
					$l--;
					if ($c =~  /[А-Я]{1}[а-я ]{$l}/) {
						$result = 2;
					}
				}
			}
			if (($result == 0) || ($l == 0)) {
				print "Грешка в $file_name елемент <$c>.\n"
				    . "Секцията <Тест> съдържа елемент, който не отговаря на правилата.\n\n";
			}
		}
	}

	# Check words
	my @w = get_words($file_name);
	for (@w) {
		my $c = $_;
		my $l = length($c);
		my $result = 0;
		if ($num <= 193) {
			if ($c =~  /[а-я ]{$l}/) {
				$result = 1;
			}
		} else {
			$l--;
			if ($c =~  /[А-Я]{1}[а-я ]{$l}/) {
				$result = 2;
			}
		}
		if ($c ne strip_line($c)) {
			$result = 3;
		}
		if (($result == 0) || ($l == 0)) {
			print "Грешка в $file_name елемент <$c>.\n"
			    . "Секцията <Думи> съдържа елемент, който не отговаря на правилата.\n\n";
		}
	}

}
