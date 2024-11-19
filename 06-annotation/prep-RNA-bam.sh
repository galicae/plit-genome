#!/usr/bin/env bash

CONVERTER=/lisc/user/papadopoulos/repos/pycno-seq/annotate/prep-RNA-sam2bam.sh

BASE="/lisc/scratch/zoology/pycnogonum/genome/draft/transcriptome"

ZYGOTE="$BASE/ZYGOTE/Aligned.out.sam"
EARLY_CLEAVAGE="$BASE/EARLY_CLEAVAGE/Aligned.out.sam"
EMBRYO0_1="$BASE/EMBRYO0_1/Aligned.out.sam"
EMBRYO3_5="$BASE/EMBRYO3_5/Aligned.out.sam"
EMBRYO9_10="$BASE/EMBRYO9_10/Aligned.out.sam"
EMBRYO3="$BASE/EMBRYO3/Aligned.out.sam"
INSTAR1="$BASE/INSTAR1/Aligned.out.sam"
INSTAR2="$BASE/INSTAR2/Aligned.out.sam"
INSTAR3="$BASE/INSTAR3/Aligned.out.sam"
INSTAR4="$BASE/INSTAR4/Aligned.out.sam"
INSTAR5="$BASE/INSTAR5/Aligned.out.sam"
INSTAR6="$BASE/INSTAR6/Aligned.out.sam"
JUV1="$BASE/JUV1/Aligned.out.sam"
SUBADULT="$BASE/SUBADULT/Aligned.out.sam"

sbatch $CONVERTER $ZYGOTE
sbatch $CONVERTER $EARLY_CLEAVAGE
sbatch $CONVERTER $EMBRYO0_1
sbatch $CONVERTER $EMBRYO3_5
sbatch $CONVERTER $EMBRYO9_10
sbatch $CONVERTER $EMBRYO3
sbatch $CONVERTER $INSTAR1
sbatch $CONVERTER $INSTAR2
sbatch $CONVERTER $INSTAR3
sbatch $CONVERTER $INSTAR4
sbatch $CONVERTER $INSTAR5
sbatch $CONVERTER $INSTAR6
sbatch $CONVERTER $JUV1
sbatch $CONVERTER $SUBADULT