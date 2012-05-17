#!/usr/bin/env python
# -*- coding: utf-8 -*-

import wordList
import codecs
#import string
import re
from itertools import chain
import sys
import ankiImport
import os

def txt2csv(filename):
    if not os.path.isabs( filename ):
        filename = os.path.abspath( filename )
    
    f = codecs.open(filename, 'r', 'utf-8')
    
    text = f.read()
    
    chapBoundry = re.compile(u'Глава (\d+)',re.UNICODE)
    
    allWords = ['',]
    
    for chapter in zip(chapBoundry.split(text)[1::2], chapBoundry.split(text)[2::2]):
        freqency = wordList.makeFreqFromText(chapter[1],allWords)
        # TODO: Fix capitals for names
        allWords = list(set(list(chain.from_iterable([ allWords, freqency.keys()]))))
        wordList.createChapterFile(filename + "{:02d}.csv".format(int(chapter[0])), freqency)
        ankiImport.import_csv(filename + "{:02d}.csv".format(int(chapter[0])),"BG", os.path.basename(filename), "{:02d}".format(int(chapter[0])))
if __name__ == '__main__':
    for filename in sys.argv[1:]:
        txt2csv(filename)
