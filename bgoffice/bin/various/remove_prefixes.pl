#!/usr/bin/perl

use strict;
require "../lib/bgoffice_util_module.pm";



if ($ARGV[0] eq "--help") {
	print <<EOHelp;

Този скрипт премахва представките и връща базата в
обратното и състояние.

Пример:
архивирам раз
вероятно не

Се променя до:
архивирам
разархивирам
вероятно
невероятно

Също така този скрипт проверява думите за повторения и ги
премахва.

EOHelp

	exit;
}



my $file_name = "";
my $num = "";

while ($file_name = next_file($file_name)) {

	print "Removing prefixes $file_name ...\n";

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

	open(OUT, ">$file_name") || die "Cannot open $file_name";

	for(@h) {
		print OUT "$_\n";
	}

	my $o = "";
	for(@w) {
		if (($_) && ($o ne $_)) {
			print OUT "$_\n";
		}
		$o = $_;
	}

	close(OUT);

}
