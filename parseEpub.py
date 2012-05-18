#!/usr/bin/env python
# -*- coding: utf-8 -*-

import wordList
#import string
import os, sys
import zipfile
import xml.dom.minidom
import BeautifulSoup
from pprint import pprint
from itertools import chain
import ankiImport


debug = True

if debug:
    try:
        from IPython.Shell import IPShellEmbed
        ipshell = IPShellEmbed()
    except:
        from IPython import embed
        ipshell = embed

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
        files = epub2csv(filename)
        for filetupple in files:
            ankiImport.import_csv(filetupple[0], filetupple[1], filetupple[2], filetupple[3] )
