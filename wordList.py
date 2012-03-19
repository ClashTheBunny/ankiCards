#!/usr/bin/env python
# -*- coding: utf-8 -*-
import codecs
#import string
import re
import bgdict
import csv

(bg_en, en_bg, bg_bg, ) = bgdict.buildDicts()

dirname = ''
filename = 'Jordan_Jovkov_-_Zhetvarjat-7865.txt'
f = codecs.open(dirname + filename, 'r', 'utf-8')

text = f.read()

def makeFileFromText(text, filename):
    wordBoundry = re.compile('\W+',re.UNICODE)

    freqDict = {}
    # TODO: Fix capitals for names
    for w in wordBoundry.split(text):
        w = w.lower()
        if freqDict.has_key(w):
            freqDict[w] += 1
        else:
            freqDict[w] = 1

    csvWriter = csv.writer(open(filename + '.csv', 'wb'))

    for tup in sorted(sorted(freqDict.items(), key=lambda x: x[0].encode('utf-8')), key=lambda x: x[1], reverse=True):
        try:
            csvWriter.writerow([tup[0].encode('utf-8') , bg_en[bg_bg[tup[0]]].encode('utf-8')] )
        except:
            try:
                csvWriter.writerow([tup[0].encode('utf-8') , bg_en[tup[0]].encode('utf-8')] )
            except:
                csvWriter.writerow([tup[0].encode('utf-8') , "Unknown"])

chapBoundry = re.compile(u'Глава (\d+)',re.UNICODE)

for chapter in zip(chapBoundry.split(text)[1::2], chapBoundry.split(text)[2::2]):
    makeFileFromText(chapter[1], filename + chapter[0] )
