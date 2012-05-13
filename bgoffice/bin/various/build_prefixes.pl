#!/usr/bin/perl

use strict;
require "../lib/bgoffice_util_module.pm";



if ($ARGV[0] eq "--help") {
	print <<EOHelp;

Този скрипт търси производни думи в рамките на един тип (файл).
Също така скрипта компресира представянето на тези думи, което
прави поддръжката на данните по-лесно. Представките се печатат
след думата разделени с интервал. Т.е. имаме:
дума представка представка ...

Пример:
архивирам
разархивирам
вероятно
невероятно

Се променя до:
архивирам раз
вероятно не

Този скрипт не проверява думите за повторения.

EOHelp

	exit;
}



my $file_name = "";
my $num = "";

while ($file_name = next_file($file_name)) {

	open(IN, "<$file_name") || die "Cannot open $file_name";
	my @d;
	@d = <IN>;
	close(IN);
	chop(@d);
	my @h = ();
	my @w = get_words($file_name);
	my $r = 0;
	for (@d) {
		if ($r == 0) {
			push(@h, $_);
			$r = (strip_line($_) eq "Думи:");
		} else {
			last;
		}
	}

	print "\n$file_name ";

	for (my $i = 0; $i <= $#w; $i++) {
		my $n = $w[$i];
		if (($n eq "") || (index($n, " ") > 0)) {
			next;
		}
		my $p = "";
		for (my $j = 0; $j <= $#w; $j++) {
			my $k = $w[$j];
			if (($k eq "") || ($i == $j)) {
				next;
			}
			if (index($k, " ") > 0) {
				my @sp = split(/ /, $k);
				$k = $sp[0];
				my $ln = length($n);
				my $lk = length($k);
				if ($ln < $lk) {
					my $pp = substr($k, $lk - $ln);
					if ($pp eq $n) {
						$pp = substr($k, 0, $lk - $ln);
						$p .= " ";
						$p .= $pp;
						for (@sp) {
							if ($k ne $_) {
								$p .= " ";
								$p .= $_;
								$p .= $pp;
							}
						}
						$w[$j] = "";
					}
				}
			} else {
				my $ln = length($n);
				my $lk = length($k);
				if ($ln < $lk) {
					my $pp = substr($k, $lk - $ln);
					if ($pp eq $n) {
						$p .= " ";
						$p .= substr($k, 0, $lk - $ln);
						$w[$j] = "";
					}
				}
			}
		}
		$w[$i] .= $p;
		if (($i % 100) == 0) {
			print ".";
		}
	}

	@w = sort(@w);

	open(OUT, ">$file_name") || die "Cannot open $file_name";
	for(@h) {
		print OUT "$_\n";
	}

	for(@w) {
		if ($_ ne "") {
			print OUT "$_\n";
		}
	}

	close(OUT);

}
