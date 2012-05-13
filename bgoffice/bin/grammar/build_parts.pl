#!/usr/bin/perl

use strict;
require "../lib/bgoffice_util_module.pm";



if ($ARGV[0] eq "--help") {
	print <<EOHelp;

���� ������ ������ ������ �������� ���� ���� �����,
���� ������� ���������� ����� ���������� ��������.
������ �������������� ���� �� ������� �� �����.


EOHelp

	exit;
}



my $file_name = "";
my $grp = "";

while ($file_name = next_file($file_name)) {

	if ($grp ne get_group($file_name)) {
		$grp = get_group($file_name);

		print "# $grp\n";

		my @w = get_forms($file_name);
		for (@w) {
			print "$_\n";
		}
	}

}
