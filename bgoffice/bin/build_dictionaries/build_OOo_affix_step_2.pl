#!/usr/bin/perl

use strict;
require "../lib/bgoffice_util_module.pm";



if ($ARGV[0] eq "--help") {
	print <<EOHelp;


���� ������ ������ ������� ���������� �� ������ 1. ����� ����
���� ����� ������ �� ����� ��������� � �� ����� ����������
������������ (sort, uniq). ������� ���� ������� �� ���� ������
� ������ ���������� ���� �� ��������.

������� � �������������� �� OpenOffice.org. �������� � �������:
SFX [letter] [Y or N] [number of affixes]
letter            = ������� �� affix_info.dat ���������� � �����
                    ��� ������� �� ����������� ������.
Y or N            = ���� ���� �� �� ��������� � �������. ������
                    ������ �������� ������ � Yes. ���� � No.
number of affixes = ���� �� �������� ���� ���� ��� (���� ��
                    ���������� � ���� ������, ����� �� ��������
                    �� �������).

�� ���������� �� ������� ������������ ���������. ���� ������:
SFX A Y 15

EOHelp

	exit;
}


my @data = <STDIN>;
chop(@data);

my $sfx = "";
my $oldsfx = "";
my @buffer = ();

for (@data) {
	$sfx = substr($_, 0, 5);
	if ($sfx ne $oldsfx) {
		if ($#buffer > 0) {
			my $n = $#buffer + 1;
			print "$oldsfx Y $n\n";
			for (@buffer) {
				print "$_\n";
			}
			print "\n";
		}
		$oldsfx = $sfx;
		@buffer = ();
	}
	push(@buffer, $_);
}

# Do not forget to flush buffer
if ($#buffer > 0) {
	my $n = $#buffer + 1;
	print "$oldsfx Y $n\n";
	for (@buffer) {
		print "$_\n";
	}
}
