#!/usr/bin/env python
# -*- coding: utf-8 -*-

import wordList
import os, sys
import zipfile
import xml.dom.minidom
import BeautifulSoup
from itertools import chain
import ankiImport
import codecs
import re

debug = False

if debug:
    try:
        from IPython.Shell import IPShellEmbed
        ipshell = IPShellEmbed()
    except:
        from IPython import embed
        ipshell = embed

def txt2csv(filename, chapRegEx):
    if not os.path.isabs( filename ):
        filename = os.path.abspath( filename )
    
    f = codecs.open(filename, 'r', 'utf-8')
    
    text = f.read()
    
    chapBoundry = re.compile(chapRegEx,re.UNICODE)
    
    allWords = ['',]

    fileList = []
    
    for chapter in zip(chapBoundry.split(text)[1::2], chapBoundry.split(text)[2::2]):
        freqency = wordList.makeFreqFromText(chapter[1],allWords)
        # TODO: Fix capitals for names
        allWords = list(set(list(chain.from_iterable([ allWords, freqency.keys()]))))
        wordList.createChapterFile(filename + "{:02d}.csv".format(int(chapter[0])), freqency)
        fileList.append((filename + "{:02d}.csv".format(int(chapter[0])), "BG", os.path.basename(filename), "{:02d}".format(int(chapter[0]))))
    return fileList

def epub2csv(filename):

    if not os.path.isabs( filename ):
        filename = os.path.abspath( filename )
    
    epub = zipfile.ZipFile(filename)
    
    metaDom = xml.dom.minidom.parseString(epub.open("META-INF/container.xml").read())
    
    opsFile = metaDom.getElementsByTagName("rootfile")[0].getAttributeNode("full-path").value
    
    opsDom = xml.dom.minidom.parseString(epub.open(opsFile).read())
    
    section = 0
    
    allWords = []

    try:
        if opsDom.getElementsByTagName("metadata")[0].getElementsByTagName("dc:title"):
            title = opsDom.getElementsByTagName("metadata")[0].getElementsByTagName("dc:title")[0].childNodes[0].data
        else:
            title = os.path.basename(filename)
        if opsDom.getElementsByTagName("metadata")[0].getElementsByTagName("dc:language"):
            language = opsDom.getElementsByTagName("metadata")[0].getElementsByTagName("dc:language")[0].childNodes[0].data
        else:
            language = "BG"
    except:
        ipshell()

    ncxFile = None

    for element in opsDom.getElementsByTagName("manifest")[0].getElementsByTagName("item"):
        if element.getAttribute("id") == "ncx":
            ncxFile = element.getAttribute("href")
            break
    if ncxFile:
        ncxDom = xml.dom.minidom.parseString(epub.open(os.path.join(os.path.dirname(opsFile),ncxFile)).read())

    fileList = []

    for chapter in opsDom.getElementsByTagName("spine")[0].getElementsByTagName("itemref"):
        section = section + 1
        for element in opsDom.getElementsByTagName("manifest")[0].getElementsByTagName("item"):
            if element.getAttribute("id") == chapter.getAttributeNode("idref").value:
                chapterFilename = element.getAttribute("href")
        if ncxFile:
            for element in ncxDom.getElementsByTagName("navMap")[0].getElementsByTagName("navPoint"):
                if element.getElementsByTagName("content")[0].getAttribute("src") == chapterFilename:
                    chapterName = element.getElementsByTagName("navLabel")[0].getElementsByTagName("text")[0].childNodes[0].data
        chapterText = epub.open(os.path.join(os.path.dirname(opsFile),chapterFilename)).read()
        soup = BeautifulSoup.BeautifulSoup(chapterText)
        body_text = ''.join(soup.body(text=True))
        freqency = wordList.makeFreqFromText(body_text,allWords)
        #print allWords
        #print freqency.keys()
        allWords = list(set(list(chain.from_iterable([ allWords, freqency.keys()]))))
        # pprint(allWords)
        wordList.createChapterFile(filename + ".cards/{:02d} - ".format(section) + chapterFilename + '.csv', freqency)
        fileList.append((filename + ".cards/{:02d} - ".format(section) + chapterFilename + '.csv', language, title, "{:02d} - ".format(section) + chapterName ))
    return fileList

if __name__ == '__main__':
    for filename in sys.argv[1:]:
        if filename.lower().endswith(".epub"):
            files = epub2csv(filename)
        elif filename.lower().endswith(".txt"):
            files = txt2csv(filename, u'Глава (\d+)')
        else:
            print "I don't think I know how to parse " + filename + " yet."
        for filetupple in files:
            ankiImport.import_csv(filetupple[0], filetupple[1], filetupple[2], filetupple[3] )
