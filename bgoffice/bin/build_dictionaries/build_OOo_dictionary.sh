#!/bin/bash

perl build_OOo_dictionary_step_1.pl > a.tmp

sort < a.tmp > b.tmp
uniq < b.tmp > a.tmp

perl build_OOo_dictionary_step_2.pl > b.tmp

sort < b.tmp > c.tmp
uniq < c.tmp > b.tmp

perl build_OOo_dictionary_step_3.pl < b.tmp >> a.tmp

# Sort in C locale as author of aspell recomends it
LC_ALL=C sort < a.tmp > b.tmp
uniq < b.tmp > a.tmp

perl build_OOo_dictionary_step_4.pl < a.tmp > b.tmp

perl -e 'my $num = `wc -l b.tmp`; chop($num); $num =~ s/\D//g; $num--; print $num;' > a.tmp

cat a.tmp b.tmp > bg_BG.dic

rm -f *.tmp
