#!/usr/bin/env python

#from anki import Collection
#col = Collection("/path/to/collection.anki2")

import os, sys
sys.path.append(os.path.join(os.path.dirname( os.path.realpath( __file__ )),"libanki") )

from anki.importing import TextImporter
import tempfile, os
import pysqlite2

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
    (fd, nam) = tempfile.mkstemp(suffix=".anki2")
    os.unlink(nam)
    return Collection(os.path.join(_defaultBase(),"User 1", "collection.anki2"), **kwargs)

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

if __name__ == "__main__":
    import_csv('/home/rmason/CalibreLibrary/Dzhoan Roulingh/Khari Potr i filosofskiiat kamk (17193)/Khari Potr i filosofskiiat kamk - Dzhoan Roulingh.epub.cards/03 - chapter-0.xhtml.csv', 'Bulgarian', 'Harry Potter and the Filosopher\'s stone', 'Chapter 1')
