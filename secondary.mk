#############################################################################
#  Description:
#
#  Copyright (c) 2021 Nokia
#############################################################################

this_dir := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
word1 = $(word 1,$(subst _, ,$@))
word2 = $(word 2,$(subst _, ,$@))
word3 = $(word 3,$(subst _, ,$@))
JOBS ?= $(shell nproc)

# nothing todo
secondary.mk: ;

include bcmsdk.mk

nfpm_yaml = \
./nfpm.yaml \
./nfpm-dbg.yaml \
./nfpm-dev.yaml

$(nfpm_yaml):
	cat $@.in | sed "s,%SDK_VERSION%,$(SDK_VERSION),g" > $@

# make pkgs word2(deb,rpm)
.PHONY: pkg_%
pkg_%: bcmsdk_all $(nfpm_yaml)
	nfpm pkg --packager $(word2) --config ./nfpm-dev.yaml --target ./
	nfpm pkg --packager $(word2) --config ./nfpm.yaml --target ./
	nfpm pkg --packager $(word2) --config ./nfpm-dbg.yaml --target ./

all: pkg_deb
clean: bcmsdk_clean
	rm -f *.deb *.rpm
clobber: bcmsdk_clobber
	rm -f *.deb *.rpm


