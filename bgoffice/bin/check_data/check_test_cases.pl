#!/usr/bin/perl

use strict;
require "../lib/bgoffice_util_module.pm";



if ($ARGV[0] eq "--help") {
	print <<EOHelp;

���� ������ ��������� ���� ��������, ����� �� ��� � �����
�������. ����� �� ������� ���� �� ���� �������� � ��
�������� ����������� ����� ���� ����. ���� ���� ����������
��������� �� �������� � ���������� ���� �� ������ ����
������.

EOHelp

	exit;
}


my $verbose = ($ARGV[0] eq "--verbose");


my $file_name = "";

while ($file_name = next_file($file_name)) {

	print "Checking $file_name ...\n" if $verbose;

	my @t = get_tests($file_name);

	if ($#t < 0) {
		next;
	}

	my @e = get_endings($file_name);

	my @gen = ();
	my $i = 0;
	my $l = 0;
	for (@t) {
		$l = $i % ($#e + 1);
		if ($l == 0) {
			@gen = build_forms($_, @e);
		} else {
			if ($_ ne $gen[$l - 1]) {
				print "������ � $file_name ������� <$_> <$gen[$l - 1]>.\n"
				    . "�������� <����> ������� �������, ����� �� �������� �� ���������.\n\n";
			}
		}
		$i++;
	}

}
