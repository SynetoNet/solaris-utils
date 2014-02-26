
DESTDIR=
PREFIX=/usr/local

.PHONY: all install clean distclean

all:

install:
	$(MAKE) -C ips DESTDIR=`readlink -f $(DESTDIR)` install
	$(MAKE) -C performance DESTDIR=`readlink -f $(DESTDIR)` install

clean:

distclean: clean
