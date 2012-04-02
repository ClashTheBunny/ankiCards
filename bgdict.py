#!/usr/bin/env python
# -*- coding: utf-8 -*-

import codecs
#from xml.etree.ElementTree import ElementTree
#from xmlDict import XmlDictConfig
import cPickle as pickle
import bz2
import sys, os
import parseWikt

def buildDicts():
    dirname = os.path.dirname(sys.argv[0])

    filename = 'bgWiktBG.pickle'
    if not os.path.isfile(os.path.join(dirname, filename)):
        parseWikt.parseBGwikt()
    f = open(os.path.join(dirname, filename), 'r')
    bg_bg = pickle.load(f)
    f.close()

    filename = 'enWiktBG.pickle'
    if not os.path.isfile(os.path.join(dirname, filename)):
        parseWikt.parseENwikt()
    f = open(os.path.join(dirname, filename), 'r')
    (bg_enWikt, en_bgWikt) = pickle.load(f)
    f.close()

    dirname = '/usr/share/bgoffice'
    filename = 'bg-en.dat'
    f = codecs.open(os.path.join(dirname, filename), 'r', 'cp1251')
    bg_enLines = f.read()
    f.close()

    bg_enEntries = bg_enLines.split('\x00')
    bg_en = {}
    for entry in bg_enEntries:
        lines = entry.split('\n')
        if not bg_enWikt.has_key(lines[0]):
            bg_en[lines[0]] = '<br>'.join(lines[1:])

    filename = 'en-bg.dat'
    f = codecs.open(os.path.join(dirname, filename), 'r', 'cp1251')
    en_bgLines = f.read()
    f.close()

    en_bgEntries = en_bgLines.split('\x00')
    en_bg = {}
    for entry in en_bgEntries:
        lines = entry.split('\n')
        if not en_bgWikt.has_key(lines[0]):
            en_bg[lines[0]] = '<br>'.join(lines[1:])

    return (bg_en,en_bg,bg_bg,bg_enWikt, en_bgWikt)
#out = codecs.open(output, 'w', 'utf-8')
#out.write(u)   # and now the contents have been output as UTF-8

if __name__ == '__main__':
    from IPython.Shell import IPShellEmbed
    ipshell = IPShellEmbed()
    (bg_en,en_bg,bg_bg,enWikt) = buildDicts()

    ipshell()
