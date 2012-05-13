#!/usr/bin/perl

use strict;
require "../lib/bgoffice_util_module.pm";



if ($ARGV[0] eq "--help") {
	print <<EOHelp;

���� ������ ���� ����� �� ����������� ���� ��� ������
[�������]-[����] � �� ������ � ���������� ����.

������:
�����-�����
�����-��������
��-��������

������ � �� �� ������������ ������� �� �������� �� ����������
����. �������� ������ ���������� ��� ������ ����� ���� ������
�����. �������� ��������� �������� �� ������ ����� � ��� �
������ ���� � ���� ��� (����) ������ ����������� ������
���������� � ���� ���. ��� ������ ����� �� �� ����� ��� ��
����� ������ �� ���� ��� ������� ������� ����������� ���������.

������ �� ������� �� ���� �� ����� � �� �� ������ �������
�������������� ����������. �� �� �� ����������� ������� ��
�������� � ������������ ����������� ���������� ������.

EOHelp

	exit;
}



# Load words
my @data = <STDIN>;
chop(@data);

# Load data files
my @words = ();
my @file_names = ();
my @wrd = ();

my $file_name = "";

my $filter_type = $ARGV[0];
if ($filter_type =~ /^male/) {
	$filter_type = "/" . $filter_type;
}

while ($file_name = next_file($file_name)) {
	if ((!($filter_type)) || ($file_name =~ /$filter_type/)) {
		@wrd = get_words($file_name);
		@wrd = sort(@wrd);
		push(@words, [ @wrd ]);
		push(@file_names, $file_name);
	}
}


for my $line (@data) {
	$line = strip_line($line);
	my $pm = index($line, "-");
	if ($pm == -1) {
		print "������ $line ���� ���������� '-' � ���. ��������� �� � ���������.\n";
		next;
	}
	my $w_search = substr($line, $pm + 1);
	my $w_add = $line;
	$w_add =~ s/-//;

	my @suggestions = ();

	for (my $i = 0; $i <= $#words; $i++) {
		@wrd = @{$words[$i]};
		if (search_in_data($w_search)) {
			push(@suggestions, $file_names[$i]);
		}
	}

	if ($#suggestions == -1) {
		print "������ $w_search �� � �������� � ������������ ���� $w_add �� � �������� � ����� ����.\n";
		next;
	}

	if ($#suggestions > 0) {
		my $cs = $#suggestions + 1;
		print "������ $w_search �� ����� $cs ���� � ������������ ���� $w_add �� � �������� � ����� ����.\n";
		for (@suggestions) {
			print "$_\n";
		}
		next;
	}

	open(OUT, ">>$suggestions[0]") || die "Cannot open $suggestions[0]";
	print OUT "$w_add\n";
	close(OUT);

	print "  $w_add - $suggestions[0]\n";

}


sub search_in_data() {
	my $w = @_[0];
	my $b = 0;
	my $e = $#wrd;
	my $m = 0;
	while (1) {
		if ($b > $e) {
			return 0;
		}
		$m = int(($b + $e) / 2);
		if ($w gt $wrd[$m]) {
			$b = $m + 1;
		} elsif ($w lt $wrd[$m]) {
			$e = $m - 1;
		} else {
			return 1;
		}
	}
}
