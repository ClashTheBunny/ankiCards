#!/usr/bin/perl

use strict;
require "../lib/bgoffice_util_module.pm";



if ($ARGV[0] eq "--help") {
	print <<EOHelp;

���� ������ ������� ����������� �� ���� ����� � affix_info.dat
����� �� ��������. �������� ��� ����� ������� -� � -�� � ����
�����. ������� �� ����� �� ����������� ���� � ������ �� �����
���������.

���� ���� ������ ����� ���������� �� ���������� �� ���������
�� OpenOffice.org �����������, ����� �� ������� �� ������
������������ ������ �� � ��-����� �� ������ ����. ������ ����
������� �� �������� �������� �� ������ ���� �� ���� ���� ��
��-����� �� �����������.

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
				print "������ � $file_name ������ <$_> � ��-���� ��� ����� �� ����������� �� ��������� <$f>.\n\n"
			}
		}
	}

}

sub check_existing() {
	my $f = @_[0];
	for (@filters) {
		my $e = $_;
		if (($f =~ /$e$/) || ($e =~ /$f$/)) {
			print "������ � $file_name �������� <$f> � <$e> ����� <$letter>.\n\n"
		}
	}
	push(@filters, $f);
}
