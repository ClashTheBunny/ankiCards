#!/usr/bin/perl

use strict;
require "../lib/bgoffice_util_module.pm";



if (($ARGV[0] eq "--help") || ($ARGV[0] eq "")) {
	print <<EOHelp;

Този скрипт генерира предложения за типа за думите от списък.
Списъкът се чете от стандартния вход. Като параметър трябва
да се предаде групата (поддиректорията), в която да се
извършва търсенето. Думите трябва да са само от тази група.
По този начин се намалява множеството от типове, в които да
се търси. Скриптът проверява думата на кои типове отговаря и
прилага правилата за генериране на словоформи. След което
печата резултата на стандартния изход.

Как да се използва.
1. Правите си списък с непознати думи, които са само
съществителни имена от мъжки род. По една дума на ред. Без да
има празни редове.
2. Стартирате програмата по следния начин:
./make_suggestions.pl /noun/male/ < words.txt > suggestions.txt

Използвайте скрипта само за съществителни имена, прилагателни
имена и глаголи. Останалите типове са попълнени или не съдържат
условия и правила за образуване на словоформите.

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
