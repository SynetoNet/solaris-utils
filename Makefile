
DESTDIR=
PREFIX=/usr/local

.PHONY: all install clean distclean

all:

install:
	$(MAKE) -C IPS-tools install
	$(MAKE) -C performance install

clean:

distclean: clean
