#!/usr/bin/perl

use strict;
require "../lib/bgoffice_util_module.pm";



if ($ARGV[0] eq "--help") {
	print <<EOHelp;

���� ������ �������� � ������ ������� �� ���������, ����� ��
������� � affix_info.dat �����.

������� � �������������� �� OpenOffice.org. �������� � �������:
[word]/[letter]
word     = ������
letter   = ������� �� affix_info.dat. ���� �� ����� ��������
           ����� ���������� ������ � ������.

���� ������:
������/F

������� �� ������ � ������ ������:
1. �������� �� ���� ������. �������� �� � �� ��������� ������������.
�������, �� ��� �������� ����� ��������� �� ��������� ���� ��� ��
��� ��� ������� ��������. �� ���� �������� � ������ �� �����.
2. �������� �� ����� �������� �� ���� ���� � �� ����� ��������� �
���������� �� �������������.
3. �������� �� ����� �������� �� ������ �� ���������, ����� �� ��
� affix_info.dat. ��� ������ ���� �� ���������� ��� ����� �� �. 2
�� �� ������ ��� ����� � �. 1.
4. ������ �� �. 3 �� ������� � �� ��������� �������������. ���� ����
�� ����� ���� ��������� ������, ����� ��������� ��� ������� ���� �
�������� ������� � �� ������ ���� �� ������ �� ������� ���.

EOHelp

	exit;
}



my $file_name = "";
my $num = "";

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

	my @w = get_words($file_name);

	for (@w) {
		print "$_/$letter\n";
	}

}
