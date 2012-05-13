#!/bin/bash

perl print_root_words.pl > root_words.dat
sort < root_words.dat | uniq > root_words_uniq.dat
uniq -i < root_words_uniq.dat > root_words_uniq_ignore_case.dat

perl print_derivative_words.pl > derivative_words.dat
sort < derivative_words.dat | uniq > derivative_words_uniq.dat
uniq -i < derivative_words_uniq.dat > derivative_words_uniq_ignore_case.dat
rm -f a.tmp

echo -n "" > statistics.dat

echo -n "Root words=" >> statistics.dat
wc -l < root_words.dat >> statistics.dat

echo -n "Uniq root words=" >> statistics.dat
wc -l < root_words_uniq.dat >> statistics.dat

echo -n "Really uniq root words=" >> statistics.dat
wc -l < root_words_uniq_ignore_case.dat >> statistics.dat

echo -n "Derivative words=" >> statistics.dat
wc -l < derivative_words.dat >> statistics.dat

echo -n "Uniq derivative words=" >> statistics.dat
wc -l < derivative_words_uniq.dat >> statistics.dat

echo -n "Really uniq derivative words=" >> statistics.dat
wc -l < derivative_words_uniq_ignore_case.dat >> statistics.dat
