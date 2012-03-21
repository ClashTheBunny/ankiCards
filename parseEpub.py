#!/usr/bin/env python
# -*- coding: utf-8 -*-

import wordList
#import string
import os
import zipfile
import xml.dom.minidom
from IPython.Shell import IPShellEmbed
import BeautifulSoup
from pprint import pprint
from itertools import chain

ipshell = IPShellEmbed()

filename = "/home/rmason/CalibreLibrary/Dzhoan Roulingh/Khari Potr i filosofskiiat kamk (17193)/Khari Potr i filosofskiiat kamk - Dzhoan Roulingh.epub"
epub = zipfile.ZipFile(filename)

metaDom = xml.dom.minidom.parseString(epub.open("META-INF/container.xml").read())

opsFile = metaDom.getElementsByTagName("rootfile")[0].getAttributeNode("full-path").value

opsDom = xml.dom.minidom.parseString(epub.open(opsFile).read())

section = 0

allWords = []

for chapter in opsDom.getElementsByTagName("spine")[0].getElementsByTagName("itemref"):
    section = section + 1
    for element in opsDom.getElementsByTagName("manifest")[0].getElementsByTagName("item"):
        if element.getAttribute("id") == chapter.getAttributeNode("idref").value:
            chapterFilename = element.getAttribute("href")
    chapterText = epub.open(os.path.join(os.path.dirname(opsFile),chapterFilename)).read()
    soup = BeautifulSoup.BeautifulSoup(chapterText)
    body_text = ''.join(soup.body(text=True))
    freqency = wordList.makeFreqFromText(body_text,allWords)
    #print allWords
    #print freqency.keys()
    allWords = list(set(list(chain.from_iterable([ allWords, freqency.keys()]))))
    # pprint(allWords)
    wordList.createChapterFile(filename + ".cards/{:02d} - ".format(section) + chapterFilename, freqency)
