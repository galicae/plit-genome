#!/usr/bin/env bash

# modify the sorted GFF3 file to conform to ENA requirements.
# this means: 
# - remove duplicate features
# - remove short introns (<10nt)

module load conda
conda activate agat-1.4.1

# switch to the submission directory
RESULT=/lisc/scratch/zoology/pycnogonum/genome/submission
cd $RESULT || exit

# define inputs and outputs
GFF=./merged_sorted_named.gff3
DEDUP=./merged_sorted_named_dedup.gff3
SHORT_INTRONS=./short_introns.tsv
KILL_LIST=./kill_list.tsv

FILTERED_GFF=./merged_sorted_named_dedup_filtered.gff3
FILTERED_mRNA=./short_introns.gff3

# the python script that will generate the kill list
KILLSCRIPT=/lisc/user/papadopoulos/repos/plit-genome/08-submission/gff-03-build_kill_list.py

# first remove duplicate features
agat_sp_fix_features_locations_duplicated.pl --gff "$GFF" -o "$DEDUP"

# now find short introns
agat_sp_list_short_introns.pl --gff "$DEDUP" --size 10 --out "$SHORT_INTRONS"

# this table contains the locus (chromosome), gene, start position, and length of 
# map the short introns to mRNAs in the GFF3 file
# this was written in Python 3.12 but Python >3 should be fine; we only use default libraries
python $KILLSCRIPT "$SHORT_INTRONS" "$DEDUP" > "$KILL_LIST"

# use the kill list to filter the offending mRNAs out of the GFF3
agat_sp_filter_feature_from_kill_list.pl --gff "$DEDUP" --kill_list "$KILL_LIST" -p mRNA -o "$FILTERED_GFF"

# also make a supplementary GFF with only the short introns:
agat_sp_filter_feature_from_keep_list.pl --gff "$DEDUP" --keep_list "$KILL_LIST" -p mRNA -o "$FILTERED_mRNA"