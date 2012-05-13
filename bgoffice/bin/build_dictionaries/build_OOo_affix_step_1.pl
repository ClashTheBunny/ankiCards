#!/usr/bin/perl

use strict;
require "../lib/bgoffice_util_module.pm";



if ($ARGV[0] eq "--help") {
	print <<EOHelp;

���� ������ �������� � ������ ������� �� ���������, ����� ��
������� � affix_info.dat �����.
������� � �������������� �� OpenOffice.org. �������� � �������:
SFX [letter] [chars to strip] [chars to add] [condition]
letter         = ������� �� affix_info.dat
chars to strip = ������� ������� �� �������� ���������
chars to add   = ���������� �������� �� �������� ���������,
                 ���������� �� ���� �� ����� ������� ���
condition      = ����� ��� ��������� � ����� �� ���������,
                 ����� �� ��������

�� ���������� �� ������� ������������ ���������. ���� ������:
SFX A ��          ��          .

�������� � � ��� ������. ���� ������� ������ �������� ���� ��
������� � �� ��������� ������������ (sort, uniq). �������
������ ���� ���������� � ������ ���������� ���� �� ����� ����
������.

EOHelp

	exit;
}



my $file_name = "";
my $num = "";
my $spaces = " " x 20;

while ($file_name = next_file($file_name)) {

	if ($file_name =~ /bg\d\d\d\.dat$/) {
		$num = substr($file_name, -9, 9);
	} else {
		$num = substr($file_name, -10, 10);
	}

	my $affix = `grep $num affix_info.dat`;
	chop($affix);
	my $letter = "";
	if ($affix) {
		$letter = substr($affix, 0, 1);
		if ($letter !~ /[A-Z]/) {
			die "Charater <$letter> is not allowed in line <$affix>.\n";
		}
	} else {
		next;
	}

	my @e = get_endings($file_name);
	my $f = $e[0];

	if ($f =~ /(.*)\[(.+)\](.*)/) {
		my $c1 = $1;
		my $c2 = $2;
		my $c3 = $3;
		my $l1 = length($c1);
		my $l2 = length($c2);
		my $l3 = length($c3);
		for (my $j = 0; $j < $l2; $j++) {
			my $replace = substr($c2, $j, 1);
			my $ff = $c1 . $replace . $c3;
			for (my $i = 1; $i <= $#e; $i++) {
				my $fe = $e[$i];
				$fe =~ s/\?/$replace/;
				print_line($ff, $fe, $letter);
			}
		}
	} else {
		for (my $i = 1; $i <= $#e; $i++) {
			print_line($f, $e[$i], $letter);
		}
	}

}

sub print_line() {
	my ($f, $e, $l) = @_;
	if (($f ne $e) && ($e ne "-")) {
		print "SFX $l   $f", substr($spaces, 0, 10 - length($f));
		my $condition = ".";
		if ($f ne "0") {
			$condition = $f;
		}
		$condition = ".";
		print $e, substr($spaces, 0, 10 - length($e)), "$condition\n";
	}
}
