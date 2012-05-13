#!/usr/bin/perl

use strict;
require "../lib/bgoffice_util_module.pm";



if (($ARGV[0] eq "--help") || ($ARGV[0] eq "")) {
	print <<EOHelp;

���� ������ ��������� ������ ���� ������� ���������� ���� �
�� �������. �������� �� ���� �� ����������� ����. ����
��������� ������ �� �� ������� ������� (���������������),
� ����� �� �� �������� ���������. ������ ������ �� �� ����
�� ���� �����. �� ���� ����� �� �������� ����������� �� ������,
� ����� �� �� �����. �������� ������ ����� ����� ������� ��
��������� � ���������� �� �������������, �� ���������
������������ ���� ������ ���������� � �������, ��� ����������
������ �� �� ������� � ������.

��� �� �� ��������.
1. ������� �� ������ �� ����, ����� �� ������ �� ����� � ������.
�������� �������� ����, ������� �� ��������. �� ���� ���� �� ���.
��� �� ��� ������ ������.
2. ���������� ���������� �� ������� �����:
./delete_words.pl /noun/male/ < words_to_delete.txt

����������� ������� ���� �� ������������� �����, ������������
����� � �������. ���������� ������ �� �������� ����� ���� � ��
��� ���� ��� ���� ����� �� ������.

���� �������� ������� ������������. �� �� ������������ �������
�� �������� � ������������ ����������� ���������� ������.

���� ���� ���� ������ ��������� ������ �� ���������� � ��
��������.

EOHelp

	exit;
}



# Load words
my @data = <STDIN>;
chop(@data);
@data = sort(@data);


my $file_name = "";

my $filter_type = $ARGV[0];
if ($filter_type =~ /^male/) {
	$filter_type = "/" . $filter_type;
}

while ($file_name = next_file($file_name)) {

	if ($file_name =~ /$filter_type/) {

		open(IN, "<$file_name") || die "Cannot open $file_name";
		my @d;
		@d = <IN>;
		close(IN);
		chop(@d);
		my @h = ();
		my @w = get_words($file_name);
		my $r = 0;
		for (@d) {
			if ($r == 0) {
				push(@h, $_);
				$r = (strip_line($_) eq "����:");
			} else {
				last;
			}
		}
		open(OUT, ">$file_name") || die "Cannot open $file_name";
		for(@h) {
			print OUT "$_\n";
		}
		my $o = "";
		for(@w) {
			if (($_) && ($o ne $_) && (!search_in_data($_))) {
				print OUT "$_\n";
			}
			$o = $_;
		}
		close(OUT);

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
