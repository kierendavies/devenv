MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --no-builtin-variables

root_dir := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
stow_packages = $(notdir $(wildcard $(root_dir)/stow/*))

.PHONY: $(stow_packages)

all: $(stow_packages)

$(stow_packages):
	stow --no-folding --dir="$(root_dir)/stow" --target="$(HOME)" --restow "$@"
