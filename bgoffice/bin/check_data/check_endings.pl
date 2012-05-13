#!/usr/bin/perl

use strict;
require "../lib/bgoffice_util_module.pm";



if ($ARGV[0] eq "--help") {
	print <<EOHelp;

���� ������ ��������� ����������� ���� ��������� �� ����������
�������. ����:
- ��������� ����� �� � ����� �� ������� ����� � ���������� �
  ����� ������.
- ��������� ���� �� �� �� �������� ���� �������� �� -�, �
  ������� �� -�� ��� -�� �� �.�. � ��.�.
- � ����� ������� �������, �� ������� ��� ����.

EOHelp

	exit;
}


my $verbose = ($ARGV[0] eq "--verbose");


my $file_name = "";
my $num = 0;

while ($file_name = next_file($file_name)) {

	if ($file_name =~ /bg\d\d\d\.dat$/) {
		$num = substr($file_name, -7, 3);
	} else {
		$num = substr($file_name, -8, 3);
	}

	if ($num > 187) {
		last;
	}

	print "Checking $file_name ...\n" if $verbose;

	my @e = get_endings($file_name);
	my $f = $e[0];
	my $ff = $e[1];
	if ($f eq "0") {
		$f = "";
	}
	if ($ff eq "0") {
		$ff = "";
	}

	if ($ff !~ /^$f$/) {
		print "������ � $file_name, ������� $e[1].\n"
		    . "��������� ����� � ������� ����� �� �� �������.\n\n";
	}

	if ($file_name =~ /\/noun\/male\//) {
		check_male_article(@e[1 .. 3]);
		check_plural_article(@e[4 .. 5]);
	} elsif ($file_name =~ /\/noun\/female\//) {
		check_female_article(@e[1 .. 2]);
		check_plural_article(@e[3 .. 4]);
	} elsif ($file_name =~ /\/noun\/neutral\//) {
		check_neutral_article(@e[1 .. 2]);
		check_plural_article(@e[3 .. 4]);
	} elsif ($file_name =~ /\/adjective\//) {
		check_adjective(@e[1 .. 9]);
	} elsif ($file_name =~ /\/verb\//) {
		check_past_tense(@e[8 .. 9]);
		check_past_tense(@e[14 .. 15]);
		check_adjective(@e[21 .. 29]);
		check_adjective(@e[30 .. 38]);
		check_adjective(@e[39 .. 47]);
		check_adjective(@e[48 .. 56]);
	}

}


sub check_adjective() {
	if ((@_[0] eq "-") && (@_[1] eq "-")) {
		return;
	}
	check_male_article2(@_[0], @_[1], @_[2]);
	check_female_article(@_[3], @_[4]);
	check_neutral_article(@_[5], @_[6]);
	check_plural_article(@_[7], @_[8]);
}

sub check_male_article() {
	if (@_[0] eq "0") {
		@_[0] = "";
	}
	if ((@_[0] . "�") ne @_[1]) {
		print "������ � $file_name, ������� @_[1].\n"
		    . "������� �� �.�. � ������� ���� �� �� �������� � �������� �� -�.\n\n";
	}
	if ((@_[0] . "��") ne @_[2]) {
		print "������ � $file_name, ������� @_[2].\n"
		    . "������� �� �.�. � ����� ���� �� �� �� �������� � �������� �� -��.\n\n";
	}
}

sub check_male_article2() {
	if (@_[0] eq "0") {
		@_[0] = "";
	}
	if (((@_[0] . "��") ne @_[1]) && ((@_[0] =~ /�$/) && ((@_[0] . "�") ne @_[1]))) {
		print "������ � $file_name, ������� @_[1].\n"
		    . "������� �� �.�. � ������� ���� �� �� �������� � �������� �� -�� ��� -�.\n\n";
	}
	if ((@_[1] . "�") ne @_[2]) {
		print "������ � $file_name, ������� @_[2].\n"
		    . "������� �� �.�. � ����� ���� �� �� �� �������� � �������� �� -�.\n\n";
	}
}

sub check_female_article() {
	if (@_[0] eq "0") {
		@_[0] = "";
	}
	if ((@_[0] . "��") ne @_[1]) {
		print "������ � $file_name, ������� @_[1].\n"
		    . "����������� ����� �� �.�. �� �� �������� � �������� �� -��.\n\n";
	}
}

sub check_neutral_article() {
	if (@_[0] eq "0") {
		@_[0] = "";
	}
	if ((@_[0] . "��") ne @_[1]) {
		print "������ � $file_name, ������� @_[1].\n"
		    . "����������� ����� �� ��.�. �� �� �������� � �������� �� -��.\n\n";
	}
}

sub check_plural_article() {
	if (@_[0] eq "0") {
		@_[0] = "";
	}
	if ((@_[0] . "��") ne @_[1]) {
		print "������ � $file_name, ������� @_[1].\n"
		    . "����������� ����� �� ��.�. �� �� �������� � �������� �� -��.\n\n";
	}
}

sub check_past_tense() {
	if (@_[0] ne @_[1]) {
		print "������ � $file_name, ������� @_[1].\n"
		    . "������� �� ������ ����� ��.�. 3�. ������ �� � ������� � ������� �� ��.�. 2�.\n\n";
	}
}
