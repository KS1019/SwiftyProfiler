prefix ?= /usr/local
bindir = $(prefix)/bin
libdir = $(prefix)/lib

toolName = swprofiler

build:
	swift build --disable-sandbox -c release
install: build
	install ".build/release/$(toolName)" "$(bindir)"

uninstall:
	rm -rf "$(bindir)/$(toolName)"

clean:
	rm -rf .build

.PHONY: build install uninstall clean