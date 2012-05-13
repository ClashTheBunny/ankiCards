#!/usr/bin/env python
# -*- coding: utf-8 -*

import xml.etree.ElementTree
import xml.dom.minidom
import re
import cPickle as pickle
from mwlib.uparser import parseString
from mwlib.xhtmlwriter import MWXHTMLWriter
import xml.etree.ElementTree as ET
import bz2
import wiktionaryGet

def parseBGwikt():
    wiktionaryGet.getWiktionaries(['bg'])
    
    fh = bz2.BZ2File("bgwiktionary-latest-pages-meta-current.xml.bz2")
    
    articles = {}
    types = {}
    
    debug = True
    if debug:
        try:
            from IPython.Shell import IPShellEmbed
            ipshell = IPShellEmbed()
        except:
            from IPython import embed
            ipshell = embed
    
    vizhRE = re.compile("#виж", re.UNICODE)
    vizhCutRE = re.compile("#виж \[\[(.*)\]\]", re.UNICODE)
    tipRE = re.compile("<title>Уикиречник:Български/Типове думи", re.UNICODE)
    tipCutRE = re.compile("Уикиречник:Български/Типове думи/([0-9].*)", re.UNICODE)
    linkCutRE = re.compile("\[\[(.*)\]\]", re.UNICODE)
    
    keep = False
    read = False
    
    while 1:
        line = fh.readline()
        if not line:
            break
        if line == "  <page>\n":
            article = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>"
            read = True
        elif line == "  </page>\n":
            read = False
            if keep:
                keep = False
                article += line
                root = xml.dom.minidom.parseString(article)
                if len(root.getElementsByTagName("text")[0].childNodes) > 0:
                    title = root.getElementsByTagName("title")[0].firstChild.data
                    text = root.getElementsByTagName("text")[0].firstChild.data
                    if vizhCutRE.search(text.encode('utf-8')):
                        articles[title] = vizhCutRE.search(text.encode('utf-8')).group(1).decode('utf-8')
                    elif tipCutRE.search(title.encode('utf-8')):
                        articles[tipCutRE.search(title.encode('utf-8')).group(1).decode('utf-8')] = text
                    elif title.encode('utf-8') == "Уикиречник:Български/Типове думи":
                        findNumberLink = re.compile("\[\[/(.*?)/\]\]")
                        for line in text.split('\n'):
                            if line.startswith('== '):
                                generalCategory = line[3:-3]
                                subCategory = ''
                                subSubCategory = ''
                            if line.startswith('=== '):
                                subCategory = line[4:-4]
                                subSubCategory = ''
                            if line.startswith('==== '):
                                subSubCategory = line[5:-5]
                            if line.startswith('['):
                                for number in findNumberLink.finditer(line):
                                    types[number.group(1)] = (generalCategory, subCategory, subSubCategory, )

        if read:
            if vizhRE.search(line) or tipRE.search(line):
                keep = True
            article += line

    wordLists = sorted([ key for key in articles.keys() if key.startswith(tuple([str(x) for x in range(0,10)])) ])

    wordType = {}

    for wordList in wordLists:
        if wordList.count("/") > 0:
            generalType = wordList[:wordList.index("/")]
        else:
            generalType = wordList
        for line in articles[wordList].split("\n"):
            if line.startswith("["):
                wordType[linkCutRE.search(line.encode('utf-8')).group(1).decode('utf-8')] = generalType
        del articles[wordList]

    bgWiktBG = bz2.BZ2File("bgWiktBG.pickle.bz2",'wb')
    
    pickle.dump((articles, wordType, types), bgWiktBG, pickle.HIGHEST_PROTOCOL)
    
    bgWiktBG.close()

def parseENwikt():
    wiktionaryGet.getWiktionaries(['en'])
    fh = bz2.BZ2File("enwiktionary-latest-pages-meta-current.xml.bz2")
    
    bg_en = {}
    en_bg = {}
    
    debug = False
    
    if debug:
        try:
            from IPython.Shell import IPShellEmbed
            ipshell = IPShellEmbed()
        except:
            from IPython import embed
            ipshell = embed
    
    cyrlRE = re.compile(ur'[\u0400-\u04FF\u0500-\u052F]', re.UNICODE)
    bulRE = re.compile("[bB]ulgarian", re.UNICODE)
    bulgarianSingle = re.compile("\* [bB]ulgarian", re.UNICODE)
    bulgarianSectionStart = re.compile("^==Bulgarian==$", re.UNICODE)
    bulgarianSectionEnd = re.compile("^==[A-Za-z-]+==$", re.UNICODE)
    
    keep = False
    read = False
    
    w = MWXHTMLWriter()
    
    while 1:
        line = fh.readline()
        if not line:
            break
        if line == "  <page>\n":
            article = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>"
            read = True
        elif line == "  </page>\n":
            read = False
            if keep:
                keep = False
                article += line
                root = xml.dom.minidom.parseString(article)
                if len(root.getElementsByTagName("text")[0].childNodes) > 0:
                    title = root.getElementsByTagName("title")[0].firstChild.data
                    text = root.getElementsByTagName("text")[0].firstChild.data
                    newText = ""
                    Bulg = False
                    for line in text.split('\n'):
                        if bulgarianSectionStart.search(line):
                            Bulg = True
                        elif bulgarianSectionEnd.search(line):
                            Bulg = False
                        if Bulg == True:
                            newText += line + '\n'
                        elif bulgarianSingle.search(line):
                            newText += line + '\n'
                    if newText is not "":
                        p = parseString(title,newText)
                        if cyrlRE.search(title):
                            if debug:
                                print "bg_en = " + newText.encode('utf-8')
                                ipshell()
                            bg_en[title] = ''.join(ET.tostring(w.write(p),encoding="utf-8",method="html").split('\n'))
                        else:
                            if debug:
                                print "en_bg = " + newText.encode('utf-8')
                                ipshell()
                            en_bg[title] = ''.join(ET.tostring(w.write(p),encoding="utf-8",method="html").split('\n'))
        if read:
            if bulRE.search(line):
                keep = True
            article += line
    
    enWiktBG = bz2.BZ2File("enWiktBG.pickle.bz2",'wb')
    
    pickle.dump((bg_en,en_bg), enWiktBG, pickle.HIGHEST_PROTOCOL)
    
    enWiktBG.close()

if __name__ == '__main__':
    #parseENwikt()
    parseBGwikt()
