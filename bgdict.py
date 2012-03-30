#!/usr/bin/env python
# -*- coding: utf-8 -*-

import codecs
#from xml.etree.ElementTree import ElementTree
#from xmlDict import XmlDictConfig
from pprint import pprint
import cPickle as pickle
import bz2
import sys, os

def buildDicts():
	dirname = '/usr/share/bgoffice'
	filename = 'bg-en.dat'
	f = codecs.open(os.path.join(dirname, filename), 'r', 'cp1251')
	bg_enLines = f.read()
        f.close()

	bg_enEntries = bg_enLines.split('\x00')
	bg_en = {}
	for entry in bg_enEntries:
		lines = entry.split('\n')
		bg_en[lines[0]] = '<br>'.join(lines[1:])

	filename = 'en-bg.dat'
	f = codecs.open(dirname + filename, 'r', 'cp1251')
	en_bgLines = f.read()
        f.close()

	en_bgEntries = en_bgLines.split('\x00')
	en_bg = {}
	for entry in en_bgEntries:
		lines = entry.split('\n')
		en_bg[lines[0]] = '<br>'.join(lines[1:])

        dirname = os.path.dirname(sys.argv[0])
	filename = 'pairs.txt.bz2'
	f = bz2.BZ2File(os.path.join(dirname, filename))
	bg_bgLines = f.read().splitlines()
        f.close()

	bg_bgEntries = bg_bgLines
	bg_bg = {}
	for entry in bg_bgEntries:
		lines = entry.split(':')
                bg_bg[lines[0]] = lines[1]

	filename = 'enWiktBG.pickle'
	f = open(os.path.join(dirname, filename), 'r')
	enWikt = pickle.load(f)
        f.close()

	return (bg_en,en_bg,bg_bg,enWikt)
#out = codecs.open(output, 'w', 'utf-8')
#out.write(u)   # and now the contents have been output as UTF-8

if __name__ == '__main__':
    pprint(buildDicts())
