
DESTDIR=
PREFIX=/usr/local

BINS=pkg_server_add pkg_server_ports

.PHONY: all install clean distclean

all:

install:
	ginstall -d -m 755 $(DESTDIR)/$(PREFIX)/bin
	for tool in $(BINS); do \
		ginstall -m 755 $${tool}.sh $(DESTDIR)/$(PREFIX)/bin/$${tool} || exit 1; \
	done

clean:

distclean: clean
