#!/usr/bin/env python

from pprint import pprint
from IPython.Shell import IPShellEmbed
import xml.etree.ElementTree
import xml.dom.minidom
import sys
import re
import cPickle as pickle
from mwlib.uparser import parseString
from mwlib.xhtmlwriter import MWXHTMLWriter
import xml.etree.ElementTree as ET

ipshell = IPShellEmbed()

fh = open("enwiktionary-latest-pages-meta-current.xml")

articles = {}

read = False

bulRE = re.compile("[bB]ulgarian", re.UNICODE)
#crylRE = re.compile("[\u0400-\u04FF\u0500-\u052F]", re.UNICODE)
bulgarianSingle = re.compile("\* [bB]ulgarian", re.UNICODE)
bulgarianSectionStart = re.compile("^==Bulgarian==$", re.UNICODE)
bulgarianSectionEnd = re.compile("^==[A-Za-z]+==$", re.UNICODE)

keep = False

debug = True

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
            article += line
            root = xml.dom.minidom.parseString(article)
            if len(root.getElementsByTagName("text")[0].childNodes) > 0:
                title = root.getElementsByTagName("title")[0].firstChild.data
                text = root.getElementsByTagName("text")[0].firstChild.data
                # massage text here.  This would be a good place to pull out only Bulgarian.
                newText = ""
                Bulg = False
                for line in text.split('\n'):
                    if bulgarianSectionEnd.search(line):
                        Bulg = False
                    elif bulgarianSectionStart.search(line):
                        Bulg = True
                    if Bulg == True:
                        newText += line
                    elif bulgarianSingle.search(line):
                        newText += line
                if newText is not "":
                    if debug:
                        print newText
                    p = parseString(title,newText)
                    articles[title] = ET.tostring(w.write(p),encoding="utf-8",method="html")
        keep = False
    if read:
        if bulRE.search(line):
            keep = True
        article += line

enWiktBG = open("enWiktBG.pickle",'wb')

pickle.dump(articles, enWiktBG, pickle.HIGHEST_PROTOCOL)

enWiktBG.close()
