#!/usr/bin/env bash

# compose the GFF3 file to prepare for ENA submission

# first gather the various input sources
BASE=/lisc/scratch/zoology/pycnogonum/genome/draft/annot_merge
ISOSEQ=$BASE/isoseq.gff
BRAKER_R1=$BASE/braker.gff
BRAKER_R2=$BASE/braker2_unique_renamed_nocodon_intron.gff3
DENOVO=$BASE/overlap_translated.gff3

ls ISOSEQ
ls BRAKER_R1
ls BRAKER_R2
ls DENOVO

# cat isoseq.gff > merged.gff3
# cat braker.gff >> merged.gff3
# cat braker2_unique_renamed_nocodon_intron.gff3 >> merged.gff3
# cat denovo_txomes/overlap_translated.gff3 >> merged.gff3
# cat ../trnascan/trnascan.gff3 >> merged.gff3
# module load genometools/
# gt gff3 -tidy -retainids -o merged_sorted.gff3 -force merged.gff3