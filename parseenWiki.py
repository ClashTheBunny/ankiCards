#!/usr/bin/env python

from pprint import pprint
from IPython.Shell import IPShellEmbed
import xml.etree.ElementTree
import xml.dom.minidom
import sys
import re
import pickle

ipshell = IPShellEmbed()

fh = open("enwiktionary-latest-pages-meta-current.xml")

articles = {}

read = False

bulRE = re.compile("[bB]ulgarian", re.UNICODE)
#crylRE = re.compile("[\u0400-\u04FF\u0500-\u052F]", re.UNICODE)

while 1:
    line = fh.readline()
    if not line:
        break
    if line == "  <page>\n":
        article = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>"
        read = True
    elif line == "  </page>\n":
        article += line
        read = False
        root = xml.dom.minidom.parseString(article)
        if len(root.getElementsByTagName("text")[0].childNodes) > 0:
            title = root.getElementsByTagName("title")[0].firstChild.data
            text = root.getElementsByTagName("text")[0].firstChild.data
            #if crylRE.search(title):
            #    articles[title] = text
            if bulRE.search(text):
                articles[title] = text
    if read:
        article += line

enWiktBG = open("enWiktBG.pickle",'wb')

pickle.dump(articles, enWiktBG)

enWiktBG.close()

print articles
