#!/usr/bin/env python
# -*- coding: utf-8 -*-

import urllib2
import re
try:
    from hashlib import md5
except ImportError:
    from md5 import md5

def getWiktionaries():
    fileRE = re.compile("pages-meta-current.xml.bz2$")
    
    debug = False
    
    if debug:
        bgmd5 = open("bgwiktionary-latest-md5sums.txt")
        enmd5 = open("enwiktionary-latest-md5sums.txt")
    else:
        bgmd5 = urllib2.urlopen("http://dumps.wikimedia.org/bgwiktionary/latest/bgwiktionary-latest-md5sums.txt")
        enmd5 = urllib2.urlopen("http://dumps.wikimedia.org/enwiktionary/latest/enwiktionary-latest-md5sums.txt")
    
    found = False
    for line in bgmd5:
        if fileRE.search(line):
            found = True
            if not (md5(open("bgwiktionary-latest-pages-meta-current.xml.bz2",'rb').read()).hexdigest() == line.strip().split(" ")[0]):
                bgWikiBZ = open("bgwiktionary-latest-pages-meta-current.xml.bz2",'wb')
                bgWikiBZ.write(urllib2.urlopen("http://dumps.wikimedia.org/bgwiktionary/latest/bgwiktionary-latest-pages-meta-current.xml.bz2").read())
                bgWikiBZ.close()
    if not found:
        print "problem with bgwiktionary-latest-md5sums.txt"
    
    found = False
    for line in enmd5:
        if fileRE.search(line):
            found = True
            if not (md5(open("enwiktionary-latest-pages-meta-current.xml.bz2",'rb').read()).hexdigest() == line.strip().split(" ")[0]):
                enWikiBZ = open("enwiktionary-latest-pages-meta-current.xml.bz2",'wb')
                enWikiBZ.write(urllib2.urlopen("http://dumps.wikimedia.org/enwiktionary/latest/enwiktionary-latest-pages-meta-current.xml.bz2").read())
                enWikiBZ.close()
    if not found:
        print "problem with enwiktionary-latest-md5sums.txt"

if __name__ == '__main__':
    getWiktionaries()
