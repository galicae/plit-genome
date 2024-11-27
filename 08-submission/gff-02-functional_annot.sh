#!/usr/bin/env bash

# wrapper script for the functional annotation of the GFF3 file, which is a jupyter notebook

module load conda

conda activate jupyterhub-5.2.1
# a conda environment that has pandas and can run jupyter notebooks

jupyter execute gff-02-functional_annot.ipynb