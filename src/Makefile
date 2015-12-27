# -*- mode: makefile-gmake; -*-

include ../Makefile.defs

.PHONY: all clean test

all:
	$(which-parallel)
	find . -mindepth 1 -maxdepth 1 ! -name '.git' -type d -exec basename {} ';' | parallel --jobs=1 $(MAKE) -C {} all

test:
	$(which-parallel)
	find . -mindepth 1 -maxdepth 1 ! -name '.git' -type d -exec basename {} ';' | parallel --jobs=1 $(MAKE) -C {} test

clean:
	find . -mindepth 1 -maxdepth 1 -type f \( -name '*~' -o -name '.DS_Store' \) -delete
	$(which-parallel)
	find . -mindepth 1 -maxdepth 1 ! -name '.git' -type d -exec basename {} ';' | parallel --jobs=1 $(MAKE) -C {} clean
