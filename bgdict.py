#!/usr/bin/env python
# -*- coding: utf-8 -*-

import codecs
import cPickle as pickle
import sys, os, bz2
import parseWikt
import re

debug = True
if __name__ == '__main__' or debug:
    try:
        from IPython.Shell import IPShellEmbed
        ipshell = IPShellEmbed()
    except:
        from IPython import embed
        ipshell = embed

def buildDicts():
    dirname = os.path.dirname(sys.argv[0])

    filename = 'bgWiktBG.pickle.bz2'
    wiktfile = 'bgwiktionary-latest-pages-meta-current.xml.bz2'
    if ( not os.path.isfile(os.path.join(dirname, filename))
        or ( os.path.getctime(os.path.join(dirname, filename)) <
            os.path.getctime(os.path.join(dirname, wiktfile)) ) ):
        parseWikt.parseBGwikt()
    f = bz2.BZ2File(os.path.join(dirname, filename), 'rb')
    (bg_bg, bg_type, bg_types ) = pickle.load(f)
    f.close()

    filename = 'enWiktBG.pickle.bz2'
    wiktfile = 'enwiktionary-latest-pages-meta-current.xml.bz2'
    if ( not os.path.isfile(os.path.join(dirname, filename))
        or ( os.path.getctime(os.path.join(dirname, filename)) <
            os.path.getctime(os.path.join(dirname, wiktfile)) ) ):
        parseWikt.parseENwikt()
    f = bz2.BZ2File(os.path.join(dirname, filename), 'rb')
    (bg_enWikt, en_bgWikt) = pickle.load(f)
    f.close()

    dirname = '/usr/share/bgoffice'
    filename = 'bg-en.dat'
    f = codecs.open(os.path.join(dirname, filename), 'r', 'cp1251')
    bg_enLines = f.read()
    f.close()

    bg_enEntries = bg_enLines.split('\x00')
    bg_en = {}
    vizhRE = re.compile(u'^вж.{0,1} ([\u0400-\u04FF\u0500-\u052F]+)$', re.UNICODE)
    for entry in bg_enEntries:
        lines = entry.split('\n')
        if not bg_enWikt.has_key(lines[0]):
            if len(lines) == 2 and vizhRE.search(lines[1]):
                bg_bg[lines[0]] = vizhRE.search(lines[1]).groups(1)[0]
            else:
                bg_en[lines[0]] = '<br>'.join(lines[1:])

    del bg_en['']

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

    return (bg_en,en_bg,bg_bg,bg_enWikt, en_bgWikt, bg_type, bg_types)

if __name__ == '__main__':
    dicts = buildDicts()
    for mydict in dicts:
        print mydict.keys()[0:10]

    ipshell()
