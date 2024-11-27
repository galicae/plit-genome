SHELL=/usr/bin/env bash

compose:
	bash gff-01-compose_gff.sh

annotate:
	module load conda
	# a conda environment that has pandas and can run jupyter notebooks
	conda activate jupyterhub-5.1.0
	jupyter nbconvert --to notebook --execute gff-02-annotate.ipynb

conform:
	bash gff-03-ENA_conform.sh

embl:
	bash gff-04-convert_to_embl.sh

validate:
	bash gff-05-submit_to_ENA.sh validate