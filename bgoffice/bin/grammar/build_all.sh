#!/bin/bash

./build_root_words.sh

./build_derivative_words.sh

perl build_types.pl > types.dat

perl build_parts.pl > parts.dat


# add fixed configuration at the end ot grammar_config.dat file
grep -v "#" config.dat | grep "." >> grammar_config.dat
