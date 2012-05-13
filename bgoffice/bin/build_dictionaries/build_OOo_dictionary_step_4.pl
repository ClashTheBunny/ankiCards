#!/usr/bin/perl

use strict;
require "../lib/bgoffice_util_module.pm";



if ($ARGV[0] eq "--help") {
	print <<EOHelp;

���� ������, ���� ������� ���������� �� �������� ������ ��
����������� ���� � �������� ������������ �� ���� � ���� ����
�� � �������� �������.
���� ������:
����/D     ��������������� ���� - ������
����/Y     �������         ���� - ������� ����
�� ���������� ��:
����/DY

������� �� ������� �� ����������� �����. ���� ���� ������ �
����� �� ������ � �� ������ �� �� �������. ������������, �����
������ �� �� ������� � �� �� ������ ���� �� ������ �� �������
��� �� �����.

EOHelp

	exit;
}

my @data = <STDIN>;
chop(@data);

my $buffer = "";
my $w = "";
my $oldw = "";
my $sfx = "";

for (@data) {
	my $p = index($_, "/");
	if ($p > 0) {
		$w = substr($_, 0, $p);
		$sfx = substr($_, $p + 1, 1);
	} else {
		$w = $_;
		$sfx = "";
	}
	if ($w eq $oldw) {
		$buffer .= $sfx;
	} else {
		if (length($buffer) > 0) {
			print "/$buffer";
		}
		print "\n$w";
		$buffer = $sfx;
	}
	$oldw = $w;
}

# Do not forget to flush buffer
if (length($buffer) > 0) {
	print "/$buffer";
}

print "\n";
