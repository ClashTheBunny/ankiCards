#!/usr/bin/env python
# -*- coding: utf-8 -*-

import cPickle as pickle
from mwlib.uparser import parseString
from mwlib.xhtmlwriter import MWXHTMLWriter
#from mwlib.dumpparser import DumpParser
import xml.etree.ElementTree as ET
#from mwlib.cdbwiki import BuildWiki

enwikt = pickle.load(open("enWiktBG.pickle"))

#print ('Anatolius',enwikt['Anatolius'])
p = parseString('Anatolius',enwikt['Anatolius'])
w = MWXHTMLWriter()
print ET.tostring(w.write(p),encoding="utf-8",method="html")
