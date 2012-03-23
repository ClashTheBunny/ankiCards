#!/usr/bin/env python
# -*- coding: utf-8 -*-

#import string
import re
import bgdict
import csv
import os

(bg_en, en_bg, bg_bg, enWikt) = bgdict.buildDicts()

def makeFreqFromText(text, usedWords):
    wordBoundry = re.compile('\W+',re.UNICODE)

    freqDict = {}
    # TODO: Fix capitals for names
    for w in wordBoundry.split(text):
        w = w.lower()
        if freqDict.has_key(w):
            freqDict[w] += 1
        else:
            freqDict[w] = 1
    for common in list(set(usedWords).intersection(freqDict.keys())):
        #print common.encode('utf-8')
        del freqDict[common]
    return freqDict

def createChapterFile(filename,freqDict):
    if not os.path.isdir(os.path.dirname(filename)):
        os.mkdir(os.path.dirname(filename))
    csvWriter = csv.writer(open(filename + '.csv', 'wb'))

    for tup in sorted(sorted(freqDict.items(), key=lambda x: x[0].encode('utf-8')), key=lambda x: x[1], reverse=True):
        try:
            csvWriter.writerow([tup[0].encode('utf-8') , enWikt[tup[0]].encode('utf-8')] )
        except:
            try:
                csvWriter.writerow([tup[0].encode('utf-8') , bg_en[bg_bg[tup[0]]].encode('utf-8')] )
            except:
                try:
                    csvWriter.writerow([tup[0].encode('utf-8') , bg_en[tup[0]].encode('utf-8')] )
                except:
                    try:
                        csvWriter.writerow([tup[0].encode('utf-8') , bg_en[tup[0].title()].encode('utf-8')] )
                    except:
                        csvWriter.writerow([tup[0].encode('utf-8') , "Unknown"])
