#!/usr/bin/env python
# -*- coding: utf-8 -*-

import xml.etree.ElementTree
import xml.dom.minidom
import re
import cPickle as pickle
from mwlib.uparser import parseString
from mwlib.xhtmlwriter import MWXHTMLWriter
import xml.etree.ElementTree as ET
import bz2


fh = bz2.BZ2File("bgwiktionary-latest-pages-meta-current.xml.bz2")

articles = {}

debug = True
if debug:
    from IPython.Shell import IPShellEmbed
    ipshell = IPShellEmbed()

vizhRE = re.compile("#виж", re.UNICODE)
# sed -e 's/<text xml:space="preserve">.*#виж \[\[\(.*\)\]\].*/<text xml:space="preserve">#виж [[\1]]/g'
vizhCutRE = re.compile("#виж \[\[(.*)\]\]", re.UNICODE)
#crylRE = re.compile("[\u0400-\u04FF\u0500-\u052F]", re.UNICODE)
#bulgarianSingle = re.compile("\* [bB]ulgarian", re.UNICODE)
#bulgarianSectionStart = re.compile("^==Bulgarian==$", re.UNICODE)
#bulgarianSectionEnd = re.compile("^==[A-Za-z]+==$", re.UNICODE)

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
#                newText = ""
#                Bulg = False
#                for line in text.split('\n'):
#                    if bulgarianSectionStart.search(line):
#                        Bulg = True
#                    elif bulgarianSectionEnd.search(line):
#                        Bulg = False
#                    if Bulg == True:
#                        newText += line + '\n'
#                    elif bulgarianSingle.search(line):
#                        newText += line + '\n'
#                if newText is not "":
#                    if debug:
#                        print newText.encode('utf-8')
                if vizhCutRE.search(text.encode('utf-8')):
                    articles[title] = vizhCutRE.search(text.encode('utf-8')).group(1).decode('utf-8')
    if read:
        if vizhRE.search(line):
            keep = True
        article += line

bgWiktBG = open("bgWiktBG.pickle",'wb')

pickle.dump(articles, bgWiktBG, pickle.HIGHEST_PROTOCOL)

bgWiktBG.close()
