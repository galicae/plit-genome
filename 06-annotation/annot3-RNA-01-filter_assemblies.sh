#!/usr/bin/env bash

FILTER=/lisc/user/papadopoulos/repos/pycno-seq/annotate/annot3-RNA-extract_complete_ORFs.sh

IN=/lisc/project/zoology/pycnogonum/transcriptome/development

EMBRYO3_5_IN=$IN/embryonic_stage3-4/Trinity.fasta
INSTAR1_IN=$IN/instarI-protonymphon/Trinity.fasta
INSTAR2_IN=$IN/instar_II/Trinity.fasta
INSTAR3_IN=$IN/instar_III/Trinity.fasta
INSTAR4_IN=$IN/instar_IV/Trinity.fasta
INSTAR5_IN=$IN/instar_V/Trinity.fasta
INSTAR6_IN=$IN/instar_VI/Trinity.fasta
JUV1_IN=$IN/juvenile_I/Trinity.fasta
SUBADULT_IN=$IN/subadult/Trinity.fasta

OUT=/lisc/scratch/zoology/pycnogonum/genome/draft/transcriptome/

EMBRYO3_5_OUT=$OUT/EMBRYO3/
INSTAR1_OUT=$OUT/INSTAR1/
INSTAR2_OUT=$OUT/INSTAR2/
INSTAR3_OUT=$OUT/INSTAR3/
INSTAR4_OUT=$OUT/INSTAR4/
INSTAR5_OUT=$OUT/INSTAR5/
INSTAR6_OUT=$OUT/INSTAR6/
JUV1_OUT=$OUT/JUV1/
SUBADULT_OUT=$OUT/SUBADULT/

sbatch $FILTER $EMBRYO3_5_IN $EMBRYO3_5_OUT
sbatch $FILTER $INSTAR1_IN $INSTAR1_OUT
sbatch $FILTER $INSTAR2_IN $INSTAR2_OUT
sbatch $FILTER $INSTAR3_IN $INSTAR3_OUT
sbatch $FILTER $INSTAR4_IN $INSTAR4_OUT
sbatch $FILTER $INSTAR5_IN $INSTAR5_OUT
sbatch $FILTER $INSTAR6_IN $INSTAR6_OUT
sbatch $FILTER $JUV1_IN $JUV1_OUT
sbatch $FILTER $SUBADULT_IN $SUBADULT_OUT