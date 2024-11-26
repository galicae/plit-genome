#!/usr/bin/env bash

# compose the GFF3 file to prepare for ENA submission

# set base and result directory
BASE=/lisc/scratch/zoology/pycnogonum/genome/draft/annot_merge
RESULT=/lisc/scratch/zoology/pycnogonum/genome/submission

# first gather the various input sources
ISOSEQ=$BASE/isoseq.gff
BRAKER_R1=$BASE/braker.gff
BRAKER_R2=$BASE/braker2_unique_renamed_nocodon_intron.gff3
DENOVO=$BASE/denovo_txomes/overlap_translated.gff3
TRNASCAN=$BASE/../trnascan/trnascan.gff3

# navigate to output directory
cd $RESULT || exit

# merge the GFF3 files
cat $ISOSEQ $BRAKER_R1 $BRAKER_R2 $DENOVO $TRNASCAN > merged.gff3

# sort the GFF3 file
module load genometools/
gt gff3 -tidy -retainids -o merged_sorted.gff3 -force merged.gff3
