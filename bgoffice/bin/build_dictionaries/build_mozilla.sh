#!/bin/bash

if ((!(test -e "bg_BG.aff")) || (!(test -e "bg_BG.dic"))); then
  echo "Building OOo affix and dictionary files first! Please wait ..."
  ./build_OOo.sh
fi

echo "Converting data ..."

./OOo2Mozilla.pl < bg_BG.aff > bg.aff

cp bg_BG.dic bg.dic

