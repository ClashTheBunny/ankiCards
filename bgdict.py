#!/usr/bin/env python
# -*- coding: utf-8 -*-

import codecs
#from xml.etree.ElementTree import ElementTree
#from xmlDict import XmlDictConfig
from pprint import pprint

def buildDicts():
	dirname = '/usr/share/bgoffice/'
	filename = 'bg-en.dat'
	f = codecs.open(dirname + filename, 'r', 'cp1251')
	bg_enLines = f.read()

	bg_enEntries = bg_enLines.split('\x00')
	bg_en = {}
	for entry in bg_enEntries:
		lines = entry.split('\n')
		bg_en[lines[0]] = '<br>'.join(lines[1:])

	filename = 'en-bg.dat'
	f = codecs.open(dirname + filename, 'r', 'cp1251')
	en_bgLines = f.read()

	en_bgEntries = en_bgLines.split('\x00')
	en_bg = {}
	for entry in en_bgEntries:
		lines = entry.split('\n')
		en_bg[lines[0]] = '<br>'.join(lines[1:])

	filename = 'pairs.txt'
	f = codecs.open(filename, 'r', 'utf8')
	bg_bgLines = f.readlines()

	bg_bgEntries = bg_bgLines
	bg_bg = {}
	for entry in bg_bgEntries:
		lines = entry.split(':')
		bg_bg[lines[0]] = ''.join(lines[1:])

	#wikiFilename = "pairs.xml"
	#tree = ElementTree()
	#tree.parse(wikiFilename)
	#root = tree.getroot()
	#wikiDict = XmlDictConfig(root)
	
	#print "Parse Finished"

	#pprint(wikiDict)

	#print "PPrint Finished"

	return (bg_en,en_bg,bg_bg,)
#out = codecs.open(output, 'w', 'utf-8')
#out.write(u)   # and now the contents have been output as UTF-8

if __name__ == '__main__':
    pprint(buildDicts())
