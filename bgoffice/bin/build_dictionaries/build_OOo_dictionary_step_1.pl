#!/usr/bin/perl

use strict;
require "../lib/bgoffice_util_module.pm";



if ($ARGV[0] eq "--help") {
	print <<EOHelp;

Този скрипт генерира и печата данните за файловете, които се
намират в affix_info.dat файла.

Справка в спецификацията на OpenOffice.org. Форматът е следния:
[word]/[letter]
word     = думата
letter   = буквата от affix_info.dat. Това се явява връзката
           между съответния суфикс и думата.

Един пример:
абажур/F

Процеса се състои в четири стъпки:
1. Генерира се този речник. Сортират се и се премахват повторенията.
Въпреки, че ако входните данни отговарят на условията няма как да
има два еднакви елемента. Но една проверка в повече не вреди.
2. Генерира се пълна разбивка на тези думи и се прави сортиране и
премахване на ограниченията.
3. Генерира се пълна разбивка на думите от файловете, които не са
в affix_info.dat. Ако дадена дума не съществува във файла от т. 2
тя се добавя към файла в т. 1.
4. Файлът от т. 3 се сортира и се премахват ограниченията. След това
се пуска през специален филтър, който обединява две еднакви думи с
различни суфикси и се печата броя на думите на първият ред.

EOHelp

	exit;
}



my $file_name = "";
my $num = "";

while ($file_name = next_file($file_name)) {

	if ($file_name =~ /bg\d\d\d\.dat$/) {
		$num = substr($file_name, -9, 9);
	} else {
		$num = substr($file_name, -10, 10);
	}

	my $affix = `grep $num affix_info.dat`;
	chop($affix);
	my $letter = "";
	if ($affix) {
		$letter = substr($affix, 0, 1);
		if ($letter !~ /[A-Z]/) {
			die "Charater <$letter> is not allowed in line <$affix>.\n";
		}
	} else {
		next;
	}

	my @w = get_words($file_name);

	for (@w) {
		print "$_/$letter\n";
	}

}
