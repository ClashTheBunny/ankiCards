#!/bin/bash

if (test -z $1); then
	echo "Checks word with prefixes."
	echo
	echo "Usage: check_words_with_prefixes.bat <prefix>"
	echo
	echo "Where prefix is some prefix in cyrillic of course."
	echo "For example ne, pre, etc."
	echo
	exit 0
fi

perl find_identical_words_step_1.pl > a.tmp

# Sort data in byte order not by locale
LC_COLLATE=C sort < a.tmp > b.tmp
uniq < b.tmp > a.tmp

grep "^$1" a.tmp > with_prefix.tmp
grep -v "^$1" a.tmp > without_prefix.tmp


perl check_words_with_prefixes.pl $1 filter > a.tmp

grep " 0$" a.tmp > no_words.txt
grep -v " 0$" a.tmp > errors.txt

rm -f *.tmp
