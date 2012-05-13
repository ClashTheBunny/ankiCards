#!/usr/bin/perl

use strict;
require "../lib/bgoffice_util_module.pm";



if ($ARGV[0] eq "--help") {
	print <<EOHelp;

���� ������ ���������� affix_info.dat ����� �� ������:
[��� �� ����], [����� �� 1 �� 26]
�� ������:
[������ �������� �����]  [��� �� ����]

������:
../../data/adjective/bg079.dat, 1
�� ���������� ��
A ../../data/adjective/bg079.dat

������� �� ����� �� ����������� ���� � �� ������� ��
����������� �����. ��������� ���� ���� �� ���� ��������
� ��� ��-����� ������� �� ������������.

EOHelp

	exit;
}



my @data = <STDIN>;
chop(@data);

for (@data) {
	my $line = strip_line($_);
	if ($line) {
		my $ind = index($line, ",");
		if ($ind < 0) {
			die "No space delimiter in line <$line>.\n";
		}
		my $ch = substr($line, $ind + 1);
		my $letter = chr(ord("A") + $ch - 1);
		if ($letter !~ /[A-Z]/) {
			die "Charater <$letter> is not allowed in line <$line>.\n";
		}
		print $letter, " ", substr($line, 0, $ind);
	}
	print "\n";

}
