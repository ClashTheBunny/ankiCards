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
                print tup[0].encode('utf-8')

chapBoundry = re.compile(u'Глава \d+',re.UNICODE)

for chapter in chapBoundry.split(text):
    print "chapter"
    print chapter.encode('utf-8')
    print "end chapter"
    makeFileFromText(chapter, filename )
