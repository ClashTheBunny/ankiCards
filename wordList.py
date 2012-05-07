#!/usr/bin/env python
# -*- coding: utf-8 -*-

#import string
import re
import bgdict
import csv
import os

(bg_en,en_bg,bg_bg,bg_enWikt, en_bgWikt) = bgdict.buildDicts()

def makeFreqFromText(text, usedWords):
    wordBoundry = re.compile('\W+',re.UNICODE)

    freqDict = {}
    # TODO: Fix capitals for names
    for w in wordBoundry.split(text):
        if w != w.lower():
            # Detect real words that are capitals
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
    if os.path.dirname(filename):
        if not os.path.isdir(os.path.dirname(filename)):
            os.mkdir(os.path.dirname(filename))
    csvWriter = csv.writer(open(filename + '.csv', 'wb'))

    for tup in sorted(sorted(freqDict.items(), key=lambda x: x[0].encode('utf-8')), key=lambda x: x[1], reverse=True):
        key = tup[0].encode('utf-8')
        value = lookupWord(tup[0])
        csvWriter.writerow([key , value])

def lookupWord(word):
    if bg_enWikt.has_key(word):
        return bg_enWikt[word]
    elif bg_bg.has_key(word):
        if bg_enWikt.has_key(bg_bg[word]):
            return bg_enWikt[bg_bg[word]]
    if bg_en.has_key(word):
        return bg_en[word].encode('utf-8')
    elif bg_bg.has_key(word):
        if bg_en.has_key(bg_bg[word]):
            return bg_en[bg_bg[word]].encode('utf-8')
    word = word.title()
    if bg_bg.has_key(word):
        word = bg_bg[word]
    if bg_enWikt.has_key(word):
        return bg_enWikt[word]
    if bg_en.has_key(word):
        return bg_en[word].encode('utf-8')
    return "Unknown"
