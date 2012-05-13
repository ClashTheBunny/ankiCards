#!/usr/bin/perl

use strict;
require "../lib/bgoffice_util_module.pm";



if (($ARGV[0] eq "--help") || ($ARGV[0] eq "")) {
	print <<EOHelp;

Този скрипт проверява базата дали съдържа определени думи и
ги изтрива. Списъкът се чете от стандартния вход. Като
параметър трябва да се предаде групата (поддиректорията),
в която да се извършва търсенето. Думите трябва да са само
от тази група. По този начин се намалява множеството от типове,
в които да се търси. Скриптът работи точно както скрипта за
сортиране и премахване на ограниченията, но проверява
допълнително дали думата съществува в списъка, ако съществува
думата не се записва в базата.

Как да се използва.
1. Правите си списък от думи, които не искате да бъдат в базата.
Примерно остарели думи, излезли от употреба. По една дума на ред.
Без да има празни редове.
2. Стартирате програмата по следния начин:
./delete_words.pl /noun/male/ < words_to_delete.txt

Използвайте скрипта само за съществителни имена, прилагателни
имена и глаголи. Останалите типове не съдържат много думи и от
тях няма кой знае какво за триене.

Тази операция разбива представките. За да компресирате данните
до варианта с представките използвайте съответния скрипт.

Също така този скрипт проверява думите за повторения и ги
премахва.

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
				$r = (strip_line($_) eq "Думи:");
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
