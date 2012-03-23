#!/usr/bin/env python
# -*- coding: utf-8 -*-

import cPickle as pickle
from mwlib.uparser import simpleparse
#from mwlib.uparser import parseString
from mwlib.xhtmlwriter import MWXHTMLWriter
import xml.etree.ElementTree as ET

enwikt = pickle.load(open("enWiktBG.pickle"))

p = simpleparse(enwikt['Anatolius'])
w = MWXHTMLWriter()
print ET.tostring(w.write(p),encoding="utf-8",method="html")
