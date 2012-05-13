#!/usr/bin/perl

use strict;
require "../lib/bgoffice_util_module.pm";



if ($ARGV[0] eq "--help") {
	print <<EOHelp;

���� ������ ��������� ������ ���� ��������� �� �������. �������� �
������ ��� �� �������� ���������.

������� � ��������������:
- �������� (������� ��� �� �������� ���������) ���� �� ���� "0" ���
  �������� �� ����� ����� � �� ������� �� ���� ���� �� ����� �����
  (���� ������ �������������� �� ����������� ������). "0" ��������,
  �� ���� ������.

EOHelp

	exit;
}

my $verbose = ($ARGV[0] eq "--verbose");


my $file_name = "";

while ($file_name = next_file($file_name)) {

	print "Checking $file_name ...\n" if $verbose;

	my $f = get_filter($file_name);
	my @e = get_endings($file_name);
	my $o = $e[0];

	if (($f eq "0") && ($o eq "0")) {
		next;
	}

	my @w = get_words($file_name);
	for (@w) {
		my $c = $_;
		if ($c !~ /$f$/) {
			print "������ � $file_name ������� <$c>.\n"
			    . "�������� <����> ������� �������, ����� �� �������� �� �������.\n\n";
		}
		if (($f ne $o) && ($o ne "0") && ($c !~ /$o$/)) {
			print "������ � $file_name ������� <$c>.\n"
			    . "�������� <����> ������� �������, ����� �� �������� �� ������� ���������.\n\n";
		}
	}

}
