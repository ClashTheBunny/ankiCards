#!/bin/bash

test -n "$(find . -maxdepth 1 -name 'bgwiktionary-*-pages-meta-current.xml.bz2' -print -quit)" || (wget http://dumps.wikimedia.org/bgwiktionary/latest/bgwiktionary-latest-pages-meta-current.xml.bz2 )
test -n "$(find . -maxdepth 1 -name 'enwiktionary-*-pages-meta-current.xml.bz2' -print -quit)" || (wget http://dumps.wikimedia.org/enwiktionary/latest/enwiktionary-latest-pages-meta-current.xml.bz2 )

(
    echo "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>"
    bzcat bgwiktionary-latest-pages-meta-current.xml.bz2 | head -1
    bzcat bgwiktionary-latest-pages-meta-current.xml.bz2  | grep -e "^<mediawiki xmlns" -e "<title>" -e "<text" | grep -B1 "#виж" | grep -v -- "^--$" | sed -e 's/<text xml:space="preserve">.*#виж \[\[\(.*\)\]\].*/<text xml:space="preserve">#виж [[\1]]/g' | sed -e 's/<title>/<page><title>/g' -e 's#</text>#</text></page>#g' -e 's#\]\]$#\]\]</text></page>#g' | grep -B1 "#виж \[" | grep -v -- "^--$"
    echo "</mediawiki>"
) | tidy -xml -utf8 | grep -e title -e \#виж | grep -v : | grep -A1 title | vim -c ":%s#</title>\n##g" -c ":%s/#виж \[\[/:/g" -c ":%s/.*<title>//" -c ":%s/\]\]//g" -c ":%s/^[^:]\+$//g" -c ":%s/^:.*//g" -c ":%s/\n^$//g" -c ":wq! pairs.txt" -
