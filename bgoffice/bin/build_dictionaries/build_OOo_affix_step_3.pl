#!/usr/bin/perl

use strict;
require "../lib/bgoffice_util_module.pm";



if ($ARGV[0] eq "--help") {
	print <<EOHelp;

���� ������ ������ ��������� �� ��������� ��� ����� bg_BG.aff.
����� ������ �� ��������� MAP � REP. �������� ������ ��������
�������, ������ �����������, ���� �������� � ������� ���� ��.

������� �� ����� �� ����������� ���� � �� ������� ��
����������� �����.

�� ��������, ������� ������ ����� �� ���������
OOo_add_to_bg_BG_aff.map
OOo_add_to_bg_BG_aff.rep (���� ���� �� ���� �� ����)
�������� �� � �� ������ ��� bg_BG.aff.

EOHelp

	exit;
}



my @data = <STDIN>;
chop(@data);

my $buf = "";
my $i = 0;

for (@data) {
	my $beg = substr($_, 0, 3);
	if (($beg eq "MAP") || ($beg eq "REP")) {
		$buf .= $_ . "\n";
		$i++;
	}
}

print "\n\n" . substr($buf, 0, 3) . " $i\n";
print "$buf";
