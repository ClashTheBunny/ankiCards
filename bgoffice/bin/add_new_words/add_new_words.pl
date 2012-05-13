#!/usr/bin/perl

use strict;
require "../lib/bgoffice_util_module.pm";



if ($ARGV[0] eq "--help") {
	print <<EOHelp;

���� ������ ���� ����� �� ����������� ���� ��� ������
[����] [����] � �� ������ � ���������� ����.

������:
����   ../../data/noun/female/bg041.dat
������   ../../data/noun/female/bg043a.dat
����   ../../data/noun/female/bg043.dat
�����   ../../data/noun/female/bg043a.dat

������ � ���� ���� �� ��������� ����������� �� ������,
������ � ��������� �� ���� ��������� � �� ���� �� ��
������� �������� �����������. �� ���� ����� ��� ������
�� ������� ���� ������� ����������� � ������� �� ������
������ � ���������� ������ (�������).

������ �� ������� �� ���� �� ����� � �� �� ������ �������
�������������� ����������. �� �� �� ����������� ������� ��
�������� � ������������ ����������� ���������� ������.

EOHelp

	exit;
}



# Load words
my @data = <STDIN>;
chop(@data);

for my $line (@data) {
	my $i = index($line, " ");
	my $word = strip_line(substr($line, 0, $i));
	my $file_name = strip_line(substr($line, $i));

	open(OUT, ">>$file_name") || die "Cannot open $file_name";
	print OUT "$word\n";
	close(OUT);

}
