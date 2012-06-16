#!/usr/bin/env python
# -*- coding: utf-8 -*-

#import string
import re
import bgdict
import csv
import os

debug = True

if debug:
    try:
        from IPython.Shell import IPShellEmbed
        ipshell = IPShellEmbed()
    except:
        from IPython import embed
        ipshell = embed

(bg_en, en_bg, bg_bg, bg_enWikt, en_bgWikt, bg_type, bg_types) = bgdict.buildDicts()

def makeFreqFromText(text, usedWords):
    wordBoundry = re.compile('\W+', re.UNICODE)

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

def createChapterFile(filename, freqDict):
    if os.path.dirname(filename):
        if not os.path.isdir(os.path.dirname(filename)):
            os.mkdir(os.path.dirname(filename))
    csvWriter = csv.writer(open(filename, 'wb'))

    for tup in sorted(sorted(freqDict.items(), key = lambda x: x[0].encode('utf-8')), key = lambda x: x[1], reverse = True):
        key = tup[0].encode('utf-8')
        value = bgen(tup[0])
        #value = lookupWord(tup[0])
        csvWriter.writerow([key , value])

def bgen(word):
    if bg_en.has_key(word):
        return bg_en[word].encode('utf-8')
    if bg_enWikt.has_key(word + u' се'):
        return bg_enWikt[word + u' се']
    if bg_en.has_key(word + u' се'):
        return bg_en[word + u' се'].encode('utf-8')
    if bg_bg.has_key(word):
        return bg_bg[word].encode('utf-8') + u': '.encode('utf-8') + bgen(bg_bg[word])
    if bg_enWikt.has_key(word):
        return bg_enWikt[word]
    if bg_type.has_key(word):
        result = u'Unknown word, word type: '
        result += u', '.join([ x for x in bg_types[bg_type[word]] if x is not ''])
        result += u' (' + bg_type[word] + u')'
        return result.encode('utf-8')
    if word != word.title():
        bgen(word.title())
    return "Unknown"
