#!/bin/bash

perl build_root_words.pl > a.tmp

tr À-ß à-ÿ < a.tmp > b.tmp

sort < b.tmp > a.tmp
uniq < a.tmp > b.tmp

perl make_fixed_size.pl no_binary < b.tmp > a.tmp
tail -n +4 a.tmp > b.tmp
LC_ALL=C sort < b.tmp > a.tmp

perl mix_identical.pl < a.tmp > b.tmp

tail -n +2 b.tmp > a.tmp

perl make_fixed_size.pl binary < a.tmp > b.tmp

# This should be the first time when grammar_config.dat is created
echo -n "RootWords.Word.MaxSize=" > grammar_config.dat
head -1 b.tmp >> grammar_config.dat

echo -n "RootWords.Types.MaxNum=" >> grammar_config.dat
head -2 b.tmp | tail -1 >> grammar_config.dat

echo -n "RootWords.Types.MaxSize=" >> grammar_config.dat
head -3 b.tmp | tail -1 >> grammar_config.dat

tail -n +4 b.tmp > root_words.dat

rm -f *.tmp
