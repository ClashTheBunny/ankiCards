#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import re

def parse(dat):
    endingsRE = re.compile("^Окончания:$")
    formiRE = re.compile("^Форми:$")
    testRE = re.compile("^Тест:$")
    blankRE = re.compile("^$")
    desc = (os.path.split(dat)[0], u'description.dat')
    datfh = open(dat, 'rb')
    descfh = open(os.path.join(*desc), 'rb')
    for fh in (descfh, datfh):
        blank = 0
        reading = False
        attrList = []
        for line in fh.readlines():
            if formiRE.match(line) or endingsRE.match(line):
                reading = True
                blank = 0
            if blankRE.match(line):
                blank += 1
            else:
                blank = 0
            if blank > 1 or testRE.match(line):
                reading = False
            if reading:
                attrList.append(line.strip())
        if fh.name[(-len('description.dat')):] == 'description.dat':
            descList = attrList
    combo = zip(descList, attrList)
    for item in combo:
        print item[0], item[1]
if __name__ == '__main__':
    parse(u'bgoffice/data/adjective/bg080.dat')
    for dirpath, dirnames, filenames in os.walk("./bgoffice/data/"):
        if 'description.dat' in filenames:
            print dirpath
            for filename in filenames:
                if filename != 'description.dat':
                    parse(os.path.join(dirpath, filename))
            # xmlFiles.append([os.path.join(dirpath, name),os.path.getmtime(os.path.join(dirpath, name)) ])
        else:
            continue
