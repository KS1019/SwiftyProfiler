prefix ?= /usr/local
bindir = $(prefix)/bin
toolName = swprofiler

build:
	swift build --disable-sandbox -c release

install: build
	mkdir -p $(bindir)
	cp -f ".build/release/$(toolName)" "$(bindir)/$(toolName)"

uninstall:
	rm -rf "$(bindir)/$(toolName)"

clean:
	rm -rf .build

.PHONY: build install uninstall clean