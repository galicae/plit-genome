#!/usr/bin/env bash

module load conda
conda activate emblmygff3

GENOME=/lisc/project/zoology/pycnogonum/paper/zenodo/results/draft.fasta
GFF=/lisc/scratch/zoology/pycnogonum/genome/submission/merged_sorted_named_dedup_flagged.gff3
RESDIR=/lisc/scratch/zoology/pycnogonum/genome/submission

cd $RESDIR || exit

EMBLmyGFF3 $GFF $GENOME \
        --topology linear \
        --molecule_type 'genomic DNA' \
        --transl_table 1  \
        --species 'Pycnogonum litorale' \
        --taxonomy INV \
        --locus_tag VPG \
        --project_id PRJEB80537 \
        -v \
        -o result.embl

gzip result.embl