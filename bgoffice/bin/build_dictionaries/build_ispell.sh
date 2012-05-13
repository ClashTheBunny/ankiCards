#!/bin/bash

if ((!(test -e "bg_BG.aff")) || (!(test -e "bg_BG.dic"))); then
  echo "Building OOo affix and dictionary files first! Please wait ..."
  ./build_OOo.sh
fi

echo "Converting data ..."

./OOo2ispell.awk < bg_BG.aff > bulgarian.aff

tail -n +2 < bg_BG.dic | LC_ALL=C sort -t/ -k1,1 -f > bulgarian.dict
