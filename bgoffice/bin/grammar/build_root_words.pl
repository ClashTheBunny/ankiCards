#!/usr/bin/perl

use strict;
require "../lib/bgoffice_util_module.pm";



if ($ARGV[0] eq "--help") {
	print <<EOHelp;

Този скрипт печата всички думи във формат "дума тип". След
това думите се сортират и се пускат през друг скрипт, който
филтрира само еднаквите думи и ги отпечатва заедно с типа.

Скриптът е подобен на скрипта за откриване на идентичните
думи, с тази разлика, че типа тук се преобразува до поредно
число и буквата отпада.


EOHelp

	exit;
}



my $file_name = "";
my $type = 0;

while ($file_name = next_file($file_name)) {

	$type++;

	my @w = get_words($file_name);
	for (@w) {
		print "$_ $type\n";
	}

}
