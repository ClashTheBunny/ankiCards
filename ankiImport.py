#!/usr/bin/env python
# -*- coding: utf-8 -*-

#from anki import Collection
#col = Collection("/path/to/collection.anki2")

import os, sys
sys.path.append(os.path.join(os.path.dirname(os.path.realpath(__file__)), "libanki"))

from anki.importing import TextImporter
import tempfile, os
import pysqlite2
import parseDoc

try:
    from aqt import mw
    Collection = mw.col
except:
    from anki import Collection
from anki.utils import isMac, isWin

def _defaultBase():
    if isWin:
        s = QSettings(QSettings.UserScope, "Microsoft", "Windows")
        s.beginGroup("CurrentVersion/Explorer/Shell Folders")
        d = s.value("Personal")
        return os.path.join(d, "Anki")
    elif isMac:
        return os.path.expanduser("~/Documents/Anki")
    else:
        return os.path.expanduser("~/Anki")

def getEmptyDeck(**kwargs):
    (fd, nam) = tempfile.mkstemp(suffix = ".anki2")
    os.unlink(nam)
    return Collection(os.path.join(_defaultBase(), "User 1", "collection.anki2"), **kwargs)

def import_csv(csvFile, lang, book, chapter):
    try:
        deck = getEmptyDeck()
    except pysqlite2.dbapi2.OperationalError as e:
        print e, "you probably have Anki open while you are running this; run this as a plugin from within Anki or close Anki and run this."
        sys.exit(1)
    m = deck.models.byName("Basic")
    deck.models.setCurrent(m)
    # set 'Import' as the target deck
    m['did'] = deck.decks.id(lang + "::" + book + "::" + chapter)
    deck.models.save(m)
    i = TextImporter(deck, csvFile)
    i.initMapping()
    i.run()
    deck.save()
    deck.close()

if __name__ == '__main__':
    for filename in sys.argv[1:]:
        if filename.lower().endswith(".epub"):
            files = parseDoc.epub2csv(filename)
        elif filename.lower().endswith(".txt"):
            files = parseDoc.txt2csv(filename, u'Глава (\d+)')
        else:
            print "I don't think I know how to parse " + filename + " yet."
        for filetupple in files:
            import_csv(filetupple[0], filetupple[1], filetupple[2], filetupple[3])
