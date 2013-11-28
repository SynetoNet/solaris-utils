
DESTDIR=
PREFIX=/usr/local

.PHONY: all install clean distclean

all:

install:
	ginstall -d -m 755 $(DESTDIR)/$(PREFIX)/
	cp -a tools $(DESTDIR)/$(PREFIX)/
	cp -a use-metrics $(DESTDIR)/$(PREFIX)/
	ginstall -d -m 755 $(DESTDIR)/$(PREFIX)/bin
	ln -s ../use-metrics/gather-use-metrics $(DESTDIR)/$(PREFIX)/bin/gather-use-metrics

clean:

distclean: clean
