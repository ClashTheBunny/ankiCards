#!/usr/bin/perl

use strict;



if (($ARGV[0] eq "--help") || ($ARGV[0] eq "")) {
	print <<EOHelp;

Този скрипт извършва проверка на думите по зададен префикс.
Файловете with_prefix и without_prefix съдържат съответните
думи с типа отпечатан на края.

Идеята е да се извърши проверка дали думите добронамерен и
недобронамерен принадлежат към един и същи тип. Разбира се от
това правило има изключения. Примерно думата мисъл е ж. р.,
а размисъл е м. р.

Стартира се файла с разширение .sh, като му се подава параметър
префикса, за който ще се извършва проверка. Изходният текст
съдържа следния вид:
недобронамерен 076 076

Ако думата без префикса не се съдържа се печата 0. На скрипта
може да се подава втори параметър да показва само думите,
които са в различни типове.

EOHelp

	exit;
}

my $prefix = $ARGV[0];
my $filter = $ARGV[1];

# Load data
open(IN, "<with_prefix.tmp") || die "Cannot open with_prefix.tmp";
my @with;
@with = <IN>;
close(IN);
chop(@with);

open(IN, "<without_prefix.tmp") || die "Cannot open without_prefix.tmp";
my @wout;
@wout = <IN>;
close(IN);
chop(@wout);

for (@with) {
	my $p = index($_, " ");
	my $word;
	my $type;
	if ($p > 0) {
		$word = substr($_, 0, $p);
		$word = substr($word, length($prefix));
		$type = substr($_, $p + 1);
	} else {
		die "no space in line <$_>\n";
	}
	if ($word ne "") {
		my $i = search_in_data($word);
		if ($i == -1) {
			print "$prefix$word - $type 0\n";
		} else {
			my $t = substr($wout[$i], index($wout[$i], " ") + 1);
			if (($t != $type) || ($filter ne "filter")) {
				print "$prefix$word - $type $t\n";
			}
		}
	}
}



sub search_in_data() {
	my $w = @_[0];
	my $b = 0;
	my $e = $#wout;
	my $m = 0;
	while (1) {
		if ($b > $e) {
			return -1;
		}
		$m = int(($b + $e) / 2);
		my $wrd = $wout[$m];
		my $p = index($wrd, " ");
		if ($p > 0) {
			$wrd = substr($wrd, 0, $p);
		} else {
			die "no space in line <$wrd>\n";
		}
		if ($w gt $wrd) {
			$b = $m + 1;
		} elsif ($w lt $wrd) {
			$e = $m - 1;
		} else {
			return $m;
		}
	}
}
