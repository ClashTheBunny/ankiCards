#!/usr/bin/perl

use strict;
require "../lib/bgoffice_util_module.pm";



if ($ARGV[0] eq "--help") {
	print <<EOHelp;

Този скрипт проверя окончанията от една група в affix_info.dat
файла за засичане. Примерно ако имаме условия -я и -яе в една
група. Данните се четат от стандартния вход и трябва да бъдат
сортирани.

Също така поради някой особености на проверката на правописа
на OpenOffice.org окончанието, което се изважда от думата
задължително трябва да е по-дълго от самата дума. Поради тази
причина се извършва проверка на всички думи от типа дали са
по-дълги от окончанието.

EOHelp

	exit;
}


my @data = <STDIN>;
chop(@data);

my $letter = "";
my $old_letter = "";
my $file_name = "";
my @filters = ();

for (@data) {

	$letter = substr($_, 0, 1);
	$file_name = strip_line(substr($_, 1));

	print "Checking $file_name ...\n";

	if ($letter ne $old_letter) {
		$old_letter = $letter;
		@filters = ();
	}

	my @e = get_endings($file_name);
	my $f = $e[0];
	my $l = 0;

	if ($f =~ /(.*)\[(.+)\](.*)/) {
		my $c1 = $1;
		my $c2 = $2;
		my $c3 = $3;
		my $l1 = length($c1);
		my $l2 = length($c2);
		my $l3 = length($c3);
		$l = $l1 + 1 + $l3;
		for (my $j = 0; $j < $l2; $j++) {
			my $replace = substr($c2, $j, 1);
			my $ff = $c1 . $replace . $c3;
			check_existing($ff);
		}
	} else {
		check_existing($f);
		$l = length($f);
	}

	if ($f ne "0") {
		my @w = get_words($file_name);
		for (@w) {
			if (length($_) <= $l) {
				print "Грешка в $file_name думата <$_> е по-къса или равна от окончанието за изваждане <$f>.\n\n"
			}
		}
	}

}

sub check_existing() {
	my $f = @_[0];
	for (@filters) {
		my $e = $_;
		if (($f =~ /$e$/) || ($e =~ /$f$/)) {
			print "Грешка в $file_name елементи <$f> и <$e> група <$letter>.\n\n"
		}
	}
	push(@filters, $f);
}
