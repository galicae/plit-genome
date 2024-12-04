SHELL=/usr/bin/env bash

compose:
	bash gff-01-compose_gff.sh

annotate:
	bash gff-02-functional_annot.sh

conform:
	bash gff-03-ENA_conform.sh

embl:
	bash gff-04-convert_to_embl.sh

validate:
	bash gff-05-submit_to_ENA.sh -validate

submit:
	bash gff-05-submit_to_ENA.sh -submit

test:
	bash gff-05-submit_to_ENA.sh -submit -test

all: compose annotate conform embl validate
	@echo Done.