#!/usr/bin/perl

use strict;
require "../lib/bgoffice_util_module.pm";



if ($ARGV[0] eq "--help") {
	print <<EOHelp;

���� ������ ����� ������ ���� �������, ����� �������� �������
�� aspell � ���������, �� �� ����� ���� �� ���������, ����� ��
�� ������� � affix_info.dat �����. ����� �� ������ ����� ����
�� �� ��������� ���� ���������� � ������� ��������� �� ��������
������. ���� ������ �� ���� �� ����������� ���� � �� ���� �
�������. ���� ���� ������� ������ �� ����� ��������� � �� ��
��������� �������������.

EOHelp

	exit;
}

my @data = <STDIN>;
chop(@data);

my $file_name = "";
my $num = "";

while ($file_name = next_file($file_name)) {

	if ($file_name =~ /bg\d\d\d\.dat$/) {
		$num = substr($file_name, -9, 9);
	} else {
		$num = substr($file_name, -10, 10);
	}

	my $affix = `grep $num affix_info.dat`;
	chop($affix);

	if (!$affix) {

		my @e = get_endings($file_name);
		my @w = get_words($file_name);

		for (@w) {
			my @gen = build_forms($_, @e);
			for (@gen) {
				if ($_ ne "-") {
					my @sp = split(/,/, $_);
					for (@sp) {
						if (!search_in_data($_)) {
							print "$_\n";
						}
					}
				}
			}
		}

	}

}

sub search_in_data() {
	my $w = @_[0];
	my $b = 0;
	my $e = $#data;
	my $m = 0;
	while (1) {
		if ($b > $e) {
			return 0;
		}
		$m = int(($b + $e) / 2);
		if ($w gt $data[$m]) {
			$b = $m + 1;
		} elsif ($w lt $data[$m]) {
			$e = $m - 1;
		} else {
			return 1;
		}
	}
}
