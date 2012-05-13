#!/usr/bin/perl

use strict;
require "../lib/bgoffice_util_module.pm";



if ($ARGV[0] eq "--help") {
	print <<EOHelp;

���� ������ ����� �������, ���������� �� ������� ������,
� �������� ������ �� ������. �������� ���� ������� ��
����������� ���� � �� ��������� �� ����������� �����.
�� ������ ��� �� ��������� ��������� �� ������.
�� ������ ��� ���� �� ��������, ����� ���� �� ��� ���� ����.
�� ������ ��� �� ��������� ��������� �� ����.


EOHelp

	exit;
}


my @data = <STDIN>;
chop(@data);
my $maxlen = 0;
my $maxtypes = 0;
my $maxtypeslen = 0;
my $spaces = 1;
my $newline = 1;

if ($ARGV[0] eq "binary") {
	$spaces = 0;
}


for(@data) {
	my @line = split(/ /, $_);
	if (length($line[0]) > $maxlen) {
		$maxlen = length($line[0]);
	}
	if ($#line > $maxtypes) {
		$maxtypes = $#line;
	}
	for (my $i = 1; $i <= $#line; $i++) {
		if (length($line[$i]) > $maxtypeslen) {
			$maxtypeslen = length($line[$i]);
		}
	}
}

print "$maxlen\n";
print "$maxtypes\n";
print "$maxtypeslen\n";

if ($spaces) {
	$maxtypeslen++;
}

for(@data) {
	my @line = split(/ /, $_);
	printf "%-${maxlen}s", $line[0];
	for (my $i = 1; $i <= $maxtypes; $i++) {
		printf "%${maxtypeslen}d", $line[$i];
	}
	if ($newline) {
		print "\n";
	}
}
