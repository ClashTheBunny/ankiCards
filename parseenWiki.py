#!/usr/bin/env python

import xml.etree.ElementTree
import xml.dom.minidom
import re
import cPickle as pickle
from mwlib.uparser import parseString
from mwlib.xhtmlwriter import MWXHTMLWriter
import xml.etree.ElementTree as ET
import bz2
import wiktionaryGet


wiktionaryGet.getWiktionaries(['en'])
fh = bz2.BZ2File("enwiktionary-latest-pages-meta-current.xml.bz2")

bg_en = {}
en_bg = {}

debug = False

if debug:
    from IPython.Shell import IPShellEmbed
    ipshell = IPShellEmbed()

crylRE = re.compile("[\u0400-\u04FF\u0500-\u052F]", re.UNICODE)
bulRE = re.compile("[bB]ulgarian", re.UNICODE)
bulgarianSingle = re.compile("\* [bB]ulgarian", re.UNICODE)
bulgarianSectionStart = re.compile("^==Bulgarian==$", re.UNICODE)
bulgarianSectionEnd = re.compile("^==[A-Za-z]+==$", re.UNICODE)

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
                    if crylRE.search(title):
                        if debug:
                            print "bg_en = " + newText.encode('utf-8')
                        bg_en[title] = ''.join(ET.tostring(w.write(p),encoding="utf-8",method="html").split('\n'))
                    else:
                        if debug:
                            print "en_bg = " + newText.encode('utf-8')
                        en_bg[title] = ''.join(ET.tostring(w.write(p),encoding="utf-8",method="html").split('\n'))
    if read:
        if bulRE.search(line):
            keep = True
        article += line

enWiktBG = open("enWiktBG.pickle",'wb')

pickle.dump((bg_en,en_bg), enWiktBG, pickle.HIGHEST_PROTOCOL)

enWiktBG.close()
