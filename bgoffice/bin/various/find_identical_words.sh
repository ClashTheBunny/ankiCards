#!/bin/bash

perl find_identical_words_step_1.pl > a.tmp

sort < a.tmp > b.tmp
uniq < b.tmp > a.tmp

perl find_identical_words_step_2.pl < a.tmp > identical.txt

rm -f *.tmp
