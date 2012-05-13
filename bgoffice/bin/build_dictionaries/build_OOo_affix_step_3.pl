#!/usr/bin/perl

use strict;
require "../lib/bgoffice_util_module.pm";



if ($ARGV[0] eq "--help") {
	print <<EOHelp;

Този скрипт добавя правилата за конверсия към файла bg_BG.aff.
Става въпрос за правилата MAP и REP. Скриптът просто филтрира
данните, орязва коментарите, брои записите и записва броя им.

Данните се четат от стандартния вход и се печатат на
стандартния изход.

На практика, скрипът приема данни от файловете
OOo_add_to_bg_BG_aff.map
OOo_add_to_bg_BG_aff.rep (този файл го няма за сега)
филтрира ги и ги добавя към bg_BG.aff.

EOHelp

	exit;
}



my @data = <STDIN>;
chop(@data);

my $buf = "";
my $i = 0;

for (@data) {
	my $beg = substr($_, 0, 3);
	if (($beg eq "MAP") || ($beg eq "REP")) {
		$buf .= $_ . "\n";
		$i++;
	}
}

print "\n\n" . substr($buf, 0, 3) . " $i\n";
print "$buf";
