#!/usr/bin/env bash

MAP=/lisc/user/papadopoulos/repos/pycno-seq/annotate/annot3-RNA-02-map_assembly_single.sh

OUT=/lisc/scratch/zoology/pycnogonum/genome/draft/transcriptome/

EMBRYO3_5=$OUT/EMBRYO3
INSTAR1=$OUT/INSTAR1
INSTAR2=$OUT/INSTAR2
INSTAR3=$OUT/INSTAR3
INSTAR4=$OUT/INSTAR4
INSTAR5=$OUT/INSTAR5
INSTAR6=$OUT/INSTAR6
JUV1=$OUT/JUV1
SUBADULT=$OUT/SUBADULT

sbatch $MAP $EMBRYO3_5/complete.fasta $EMBRYO3_5
sbatch $MAP $INSTAR1/complete.fasta $INSTAR1
sbatch $MAP $INSTAR2/complete.fasta $INSTAR2
sbatch $MAP $INSTAR3/complete.fasta $INSTAR3
sbatch $MAP $INSTAR4/complete.fasta $INSTAR4
sbatch $MAP $INSTAR5/complete.fasta $INSTAR5
sbatch $MAP $INSTAR6/complete.fasta $INSTAR6
sbatch $MAP $JUV1/complete.fasta $JUV1
sbatch $MAP $SUBADULT/complete.fasta $SUBADULT