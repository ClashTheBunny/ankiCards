#!/usr/bin/perl

use strict;
require "../lib/bgoffice_util_module.pm";



if ($ARGV[0] eq "--help") {
	print <<EOHelp;

Този скрипт чете данни от стандартния вход във формат
[префикс]-[дума] и ги добавя в съответния файл.

Пример:
видео-карта
бързо-действие
не-съгласие

Идеята е да се автоматизира процеса на добавяне на производни
думи. Очевидно думата видеокарта има същите форми като думата
карта. Скриптът проверява типовете за думата карта и ако я
намери само в един тип (файл) добавя автоматично думата
видеокарта в този тип. Ако думата карта не се среща или се
среща повече от един път скрипта изважда съответните съобщения.

Думите се добавят на края на файла и не се вземат предвид
съществуващите представки. За да се компресират данните до
варианта с представките използвайте съответния скрипт.

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
		print "Думата $line няма разделител '-' в нея. Обработка не е извършена.\n";
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
		print "Думата $w_search не е намерена и производната дума $w_add не е добавена в никой файл.\n";
		next;
	}

	if ($#suggestions > 0) {
		my $cs = $#suggestions + 1;
		print "Думата $w_search се среща $cs пъти и производната дума $w_add не е добавена в никой файл.\n";
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
