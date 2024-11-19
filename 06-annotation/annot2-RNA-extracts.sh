#!/usr/bin/env bash

EXTRACT=/lisc/user/papadopoulos/repos/pycno-seq/annotate/annot2-RNA-extract_uncovered.sh

BASE=/lisc/scratch/zoology/pycnogonum/genome/draft/transcriptome/

sbatch $EXTRACT "$BASE/ZYGOTE/"
sbatch $EXTRACT "$BASE/EARLY_CLEAVAGE/"
sbatch $EXTRACT "$BASE/EMBRYO0_1/"
sbatch $EXTRACT "$BASE/EMBRYO3_5/"
sbatch $EXTRACT "$BASE/EMBRYO9_10/"
sbatch $EXTRACT "$BASE/EMBRYO3/"
sbatch $EXTRACT "$BASE/INSTAR1/"
sbatch $EXTRACT "$BASE/INSTAR2/"
sbatch $EXTRACT "$BASE/INSTAR3/"
sbatch $EXTRACT "$BASE/INSTAR4/"
sbatch $EXTRACT "$BASE/INSTAR5/"
sbatch $EXTRACT "$BASE/INSTAR6/"
sbatch $EXTRACT "$BASE/JUV1/"
sbatch $EXTRACT "$BASE/SUBADULT/"