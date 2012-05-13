#!/bin/bash

perl build_OOo_affix_header.pl > bg_BG.aff

perl build_OOo_affix_step_1.pl > a.tmp

sort < a.tmp > b.tmp
uniq < b.tmp > a.tmp

perl build_OOo_affix_step_2.pl < a.tmp >> bg_BG.aff

perl build_OOo_affix_step_3.pl < OOo_add_to_bg_BG_aff.map >> bg_BG.aff


rm -f *.tmp
