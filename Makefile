ifeq ($(RUST_TARGET),)
	TARGET := ""
	RELEASE_SUFFIX := ""
else
	TARGET := $(RUST_TARGET)
	RELEASE_SUFFIX := "-$(TARGET)"
	export CARGO_BUILD_TARGET = $(RUST_TARGET)
endif

VERSION := $(word 3,$(shell grep -m1 "^version" Cargo.toml))
RELEASE := spotify-tui-$(VERSION)$(RELEASE_SUFFIX)

all: release

spt:
	cargo build --locked --release

bin:
	mkdir -p $@

bin/spt: spt bin
	cp -f target/$(TARGET)/release/spt $@

release: bin/spt
	tar -C bin -Jcvf $(RELEASE).tar.xz spt

.PHONY: all release
