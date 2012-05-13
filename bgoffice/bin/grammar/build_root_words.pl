#!/usr/bin/perl

use strict;
require "../lib/bgoffice_util_module.pm";



if ($ARGV[0] eq "--help") {
	print <<EOHelp;

���� ������ ������ ������ ���� ��� ������ "���� ���". ����
���� ������ �� �������� � �� ������ ���� ���� ������, �����
�������� ���� ��������� ���� � �� ��������� ������ � ����.

�������� � ������� �� ������� �� ��������� �� �����������
����, � ���� �������, �� ���� ��� �� ����������� �� �������
����� � ������� ������.


EOHelp

	exit;
}



my $file_name = "";
my $type = 0;

while ($file_name = next_file($file_name)) {

	$type++;

	my @w = get_words($file_name);
	for (@w) {
		print "$_ $type\n";
	}

}
