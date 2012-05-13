#!/usr/bin/perl

use strict;
require "../lib/bgoffice_util_module.pm";



if ($ARGV[0] eq "--help") {
	print <<EOHelp;

���� ������ ���������� ����� ������ �� ����� �����
�� ������� �����:
SFX K   �         ���      .
��
SFX K   �         ���      a

������� �� ���� �� ������ ��� ����� (�������) ��
������� �������.

������� �� ����� �� ����������� ���� � �� ������� ��
����������� �����.

EOHelp

	exit;
}



my @data = <STDIN>;
chop(@data);

my $old_line = "";

for (@data) {
	my $line = $_;
	my $beg = substr($_, 0, 3);
	if ($beg eq "SET") {
		print "SET windows-1251\n";
		next;
	}
	if (($beg eq "MAP") || ($beg eq "REP")) {
		exit;
	}
	if (($_ eq "") && ($old_line eq "")) {
		next;
	}
	if ((length($line) == 29) && (substr($line, 28, 1) eq ".") && (substr($line, 8, 1) ne "0")) {
		print substr($line, 0, 28);
		print strip_line(substr($line, 8, 10));
		print "\n";
	} else {
		print "$_\n";
	}
	$old_line = $_;
}
