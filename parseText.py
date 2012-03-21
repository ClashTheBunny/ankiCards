#!/usr/bin/env python
# -*- coding: utf-8 -*-

import wordList
import codecs
#import string
import re
from itertools import chain

dirname = ''
filename = './Jordan_Jovkov_-_Zhetvarjat-7865.txt'
f = codecs.open(dirname + filename, 'r', 'utf-8')

text = f.read()

chapBoundry = re.compile(u'Глава (\d+)',re.UNICODE)

allWords = []

for chapter in zip(chapBoundry.split(text)[1::2], chapBoundry.split(text)[2::2]):
    freqency = wordList.makeFreqFromText(chapter[1],allWords)
    # TODO: Fix capitals for names
    allWords = list(set(list(chain.from_iterable([ allWords, freqency.keys()]))))
    wordList.createChapterFile(filename + chapter[0], freqency)
