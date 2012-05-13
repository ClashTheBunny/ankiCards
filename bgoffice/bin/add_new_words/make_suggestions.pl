#!/usr/bin/perl

use strict;
require "../lib/bgoffice_util_module.pm";



if (($ARGV[0] eq "--help") || ($ARGV[0] eq "")) {
	print <<EOHelp;

���� ������ �������� ����������� �� ���� �� ������ �� ������.
�������� �� ���� �� ����������� ����. ���� ��������� ������
�� �� ������� ������� (���������������), � ����� �� ��
�������� ���������. ������ ������ �� �� ���� �� ���� �����.
�� ���� ����� �� �������� ����������� �� ������, � ����� ��
�� �����. �������� ��������� ������ �� ��� ������ �������� �
������� ��������� �� ���������� �� ����������. ���� �����
������ ��������� �� ����������� �����.

��� �� �� ��������.
1. ������� �� ������ � ��������� ����, ����� �� ����
������������� ����� �� ����� ���. �� ���� ���� �� ���. ��� ��
��� ������ ������.
2. ���������� ���������� �� ������� �����:
./make_suggestions.pl /noun/male/ < words.txt > suggestions.txt

����������� ������� ���� �� ������������� �����, ������������
����� � �������. ���������� ������ �� ��������� ��� �� ��������
������� � ������� �� ���������� �� ������������.

EOHelp

	exit;
}



# Load words
my @data = <STDIN>;
chop(@data);


# Load data files
my @types = ();
my @filters = ();
my @file_names = ();

my $file_name = "";

my $filter_type = $ARGV[0];
if ($filter_type =~ /^male/) {
	$filter_type = "/" . $filter_type;
}

while ($file_name = next_file($file_name)) {
	if ($file_name =~ /$filter_type/) {
		push(@types, [ get_endings($file_name) ]);
		push(@filters, get_filter($file_name));
		push(@file_names, $file_name);
	}
}

for my $word (@data) {
	for (my $i = 0; $i <= $#types; $i++) {
		my $f = $filters[$i];
		if (($word =~ /$f$/) || ($f eq "0")) {
			print $word, "   ", $file_names[$i], "\n";
			my @gen = build_forms($word, @{$types[$i]});
			for (@gen) {
				print "$_\n";
			}
			print "\n\n";
		}
	}
	print "############################################\n\n\n";

}
