# -*- coding: utf-8 -*-

PJTDIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))


.PHONY: notebook

notebook:
	@ docker run --rm -p 8888:8888 \
		-w /home/jovyan/work \
		-v $(PJTDIR)/notebook:/home/jovyan/work \
		blue271828/nlp100-2015
