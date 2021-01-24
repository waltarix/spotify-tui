ifeq ($(RUST_TARGET),)
	TARGET :=
	RELEASE_SUFFIX :=
else
	TARGET := $(RUST_TARGET)
	RELEASE_SUFFIX := -$(TARGET)
	export CARGO_BUILD_TARGET = $(RUST_TARGET)
endif

PROJECT_NAME := spotify-tui
BINARY_NAME  := spt

VERSION := $(subst $\",,$(word 3,$(shell grep -m1 "^version" Cargo.toml)))
RELEASE := $(PROJECT_NAME)-$(VERSION)$(RELEASE_SUFFIX)

DIST_DIR := dist
RELEASE_DIR := $(DIST_DIR)/$(RELEASE)

BINARY := target/$(TARGET)/release/$(BINARY_NAME)

RELEASE_BINARY := $(RELEASE_DIR)/$(BINARY_NAME)

ARTIFACT := $(RELEASE).tar.xz

.PHONY: all
all: $(ARTIFACT)

$(BINARY):
	RUSTFLAGS='-C link-args=-s' cargo build --locked --release

$(DIST_DIR) $(RELEASE_DIR):
	mkdir -p $@

$(RELEASE_BINARY): $(BINARY) $(RELEASE_DIR)
	cp -f $< $@

$(ARTIFACT): $(RELEASE_BINARY)
	tar -C $(DIST_DIR) -Jcvf $@ $(RELEASE)

.PHONY: clean
clean:
	$(RM) -rf $(ARTIFACT) $(DIST_DIR)
