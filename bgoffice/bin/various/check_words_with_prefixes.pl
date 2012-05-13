#!/usr/bin/perl

use strict;



if (($ARGV[0] eq "--help") || ($ARGV[0] eq "")) {
	print <<EOHelp;

���� ������ �������� �������� �� ������ �� ������� �������.
��������� with_prefix � without_prefix �������� �����������
���� � ���� ��������� �� ����.

������ � �� �� ������� �������� ���� ������ ������������ �
�������������� ����������� ��� ���� � ���� ���. ������� �� ��
���� ������� ��� ����������. �������� ������ ����� � �. �.,
� �������� � �. �.

�������� �� ����� � ���������� .sh, ���� �� �� ������ ���������
��������, �� ����� �� �� �������� ��������. ��������� �����
������� ������� ���:
�������������� 076 076

��� ������ ��� �������� �� �� ������� �� ������ 0. �� �������
���� �� �� ������ ����� ��������� �� ������� ���� ������,
����� �� � �������� ������.

EOHelp

	exit;
}

my $prefix = $ARGV[0];
my $filter = $ARGV[1];

# Load data
open(IN, "<with_prefix.tmp") || die "Cannot open with_prefix.tmp";
my @with;
@with = <IN>;
close(IN);
chop(@with);

open(IN, "<without_prefix.tmp") || die "Cannot open without_prefix.tmp";
my @wout;
@wout = <IN>;
close(IN);
chop(@wout);

for (@with) {
	my $p = index($_, " ");
	my $word;
	my $type;
	if ($p > 0) {
		$word = substr($_, 0, $p);
		$word = substr($word, length($prefix));
		$type = substr($_, $p + 1);
	} else {
		die "no space in line <$_>\n";
	}
	if ($word ne "") {
		my $i = search_in_data($word);
		if ($i == -1) {
			print "$prefix$word - $type 0\n";
		} else {
			my $t = substr($wout[$i], index($wout[$i], " ") + 1);
			if (($t != $type) || ($filter ne "filter")) {
				print "$prefix$word - $type $t\n";
			}
		}
	}
}



sub search_in_data() {
	my $w = @_[0];
	my $b = 0;
	my $e = $#wout;
	my $m = 0;
	while (1) {
		if ($b > $e) {
			return -1;
		}
		$m = int(($b + $e) / 2);
		my $wrd = $wout[$m];
		my $p = index($wrd, " ");
		if ($p > 0) {
			$wrd = substr($wrd, 0, $p);
		} else {
			die "no space in line <$wrd>\n";
		}
		if ($w gt $wrd) {
			$b = $m + 1;
		} elsif ($w lt $wrd) {
			$e = $m - 1;
		} else {
			return $m;
		}
	}
}
