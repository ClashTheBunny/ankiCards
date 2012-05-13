#!/usr/bin/perl

use strict;
require "../lib/bgoffice_util_module.pm";



if ($ARGV[0] eq "--help") {
	print <<EOHelp;

���� ������ �������� ������� �� aspell. ������ �� ������ � ��
�������� ����������� � ������� �� ������� �� ����������� �����.
���� ���� ������ ������ �� ����� ��������� � ������������ ������
�� ����� ����������. �.�. �� �� ������ ���� sort � uniq.

���� �� �� ������ �:
--before187 �� �������� �� 1 �� 187
--after187 �� �������� ���� 187.
��� ��������� �� �������� �� ������ ������.

EOHelp

	exit;
}



my $file_name = "";
my $num = 0;

while ($file_name = next_file($file_name)) {

	if ($file_name =~ /bg\d\d\d\.dat$/) {
		$num = substr($file_name, -7, 3);
	} else {
		$num = substr($file_name, -8, 3);
	}

	if (($ARGV[0] eq "--before187") && ($num > 187)) {
		last;
	}
	if (($ARGV[0] eq "--after187") && ($num < 188)) {
		next;
	}

	my @e = get_endings($file_name);
	my @w = get_words($file_name);

	for (@w) {
		my @gen = build_forms($_, @e);
		for (@gen) {
			if ($_ ne "-") {
				my @sp = split(/,/, $_);
				for (@sp) {
					print "$_\n";
				}
			}
		}
	}

}
