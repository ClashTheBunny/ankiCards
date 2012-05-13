#!/bin/bash

perl build_derivative_words.pl < root_words.dat > a.tmp

tr À-ß à-ÿ < a.tmp > b.tmp

sort < b.tmp > a.tmp
uniq < a.tmp > b.tmp

perl mix_identical.pl < b.tmp > derivative_words.dat

tail -n +2 derivative_words.dat > a.tmp
perl make_fixed_size.pl no_binary < a.tmp > b.tmp

echo -n "DerivativeWords.Word.MaxSize=" >> grammar_config.dat
head -1 b.tmp >> grammar_config.dat

echo -n "DerivativeWords.Types.MaxNum=" >> grammar_config.dat
head -2 b.tmp | tail -1 >> grammar_config.dat

echo -n "DerivativeWords.Types.MaxSize=" >> grammar_config.dat
head -3 b.tmp | tail -1 >> grammar_config.dat

rm -f *.tmp
