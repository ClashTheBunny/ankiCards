#!/usr/bin/perl

use strict;
require "../lib/bgoffice_util_module.pm";



if ($ARGV[0] eq "--help") {
	print <<EOHelp;

���� ������ ���������, ���� ������������ ������� � ����������
������ ��������� �� ���������.

������� � ��������������:
- �������� (������� ��� �� �������� ���������) ���� �� ���� "0" ���
  �������� �� ����� ����� � �� ������� �� ���� ���� �� ����� �����
  (���� ������ �������������� �� ����������� ������).
- ���������� ���������, ����� �� ����� "0", "-" ��� ����� ����� � ��
  �������� "?" ��� ����� ���� ��� �������.
- ���� ���������� ����� �� ����� "-" ��� ����� �����.
- ������, ����� �� �������� ���� ����� ����� �� (�����������) ���
  193 � �� ��� 194 �� ���� ������� ����� ������ �� ���� ������.
  ������ ����� �� ���� ���������� ��������� � �������� ���� ����
  �� ������.

�������� ��������� � ����, ����� �� �������� ������ �� ���� �������
�� ��� �������� ��� ��������� (",").

EOHelp

	exit;
}


my $verbose = ($ARGV[0] eq "--verbose");


my $file_name = "";
my $num = 0;

while ($file_name = next_file($file_name)) {

	print "Checking $file_name ...\n" if $verbose;

	if ($file_name =~ /bg\d\d\d[.]dat$/) {
		$num = substr($file_name, -7, 3);
	} else {
		$num = substr($file_name, -8, 3);
	}

	my @e = get_endings($file_name);

	# Check filter
	my $c = $e[0];
	my $l = length($c);
	my $has_class = 0;
	my $result = 0;
	if ($c eq "0") {
		$result = 1;
	} elsif ($c =~  /[�-�]{$l}/) {
		$result = 2;
	} elsif ($c =~ /(.*)\[(.+)\](.*)/) {
		$has_class = 1;
		my $c1 = $1;
		my $c2 = $2;
		my $c3 = $3;
		my $l1 = length($c1);
		my $l2 = length($c2);
		my $l3 = length($c3);
		if (($c1 =~  /[�-�]{$l1}/) && ($c2 =~  /[�-�]{$l2}/) && ($c3 =~  /[�-�]{$l3}/)) {
			$result = 3;
		}
	}
	if (($result == 0) || ($l == 0)) {
		print "������ � $file_name ������� <$c>.\n"
		    . "�������� <���������> (<������>) ������� �������, ����� �� �������� �� ���������.\n\n";
	}

	# Check endigns
	my $i = 0;
	for (@e) {
		if ($i == 0) {
			$i++;
			next;
		}
		my @sp = split(/,/, $_);
		# Tricky part. If edns with , just add empty element.
		if ($_ =~ /,$/) {
			push(@sp, "");
		}
		for (@sp) {
			my $c = strip_line($_);
			my $l = length($c);
			my $result = 0;
			if ($c eq "0") {
				$result = 1;
			} elsif ($c eq "-") {
				$result = 4;
			} elsif (($has_class == 0) && ($c =~  /[�-�]{$l}/)) {
				$result = 2;
			} elsif ($has_class == 1) {
				if ($c =~ /(.*)\?(.*)/) {
					my $c1 = $1;
					my $c2 = $2;
					my $l1 = length($c1);
					my $l2 = length($c2);
					if (($c1 =~  /[�-�]{$l1}/) && ($c2 =~  /[�-�]{$l2}/)) {
						$result = 3;
					}
				} elsif ((($num == 145) || ($num == 18)) && ($c =~  /[�-�]{$l}/)) {
					# Some cases in 145 and 18a do not have ?
					$result = 3;
				}
			}
			if (($result == 0) || ($l == 0)) {
				print "������ � $file_name ������� <$c>.\n"
				    . "�������� <���������> ������� �������, ����� �� �������� �� ���������.\n\n";
			}
		}
	}

	# Check tests
	my @t = get_tests($file_name);
	for (@t) {
		my @sp = split(/,/, $_);
		# Tricky part. If edns with , just add empty element.
		if ($_ =~ /,$/) {
			push(@sp, "");
		}
		for (@sp) {
			my $c = strip_line($_);
			my $l = length($c);
			my $result = 0;
			if ($c eq "-") {
				$result = 4;
			} else {
				if ($num <= 193) {
					if ($c =~  /[�-� ]{$l}/) {
						$result = 1;
					}
				} else {
					$l--;
					if ($c =~  /[�-�]{1}[�-� ]{$l}/) {
						$result = 2;
					}
				}
			}
			if (($result == 0) || ($l == 0)) {
				print "������ � $file_name ������� <$c>.\n"
				    . "�������� <����> ������� �������, ����� �� �������� �� ���������.\n\n";
			}
		}
	}

	# Check words
	my @w = get_words($file_name);
	for (@w) {
		my $c = $_;
		my $l = length($c);
		my $result = 0;
		if ($num <= 193) {
			if ($c =~  /[�-� ]{$l}/) {
				$result = 1;
			}
		} else {
			$l--;
			if ($c =~  /[�-�]{1}[�-� ]{$l}/) {
				$result = 2;
			}
		}
		if ($c ne strip_line($c)) {
			$result = 3;
		}
		if (($result == 0) || ($l == 0)) {
			print "������ � $file_name ������� <$c>.\n"
			    . "�������� <����> ������� �������, ����� �� �������� �� ���������.\n\n";
		}
	}

}
