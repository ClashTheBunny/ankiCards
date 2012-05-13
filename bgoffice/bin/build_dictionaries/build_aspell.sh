#!/bin/bash

perl build_aspell_dictionary.pl > a.tmp

# Sort in C locale as author of aspell recomends it
LC_ALL=C sort < a.tmp > b.tmp
uniq < b.tmp > bg_words.dat

rm -f *.tmp
