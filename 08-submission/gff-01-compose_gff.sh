#!/usr/bin/env bash

# compose the GFF3 file to prepare for ENA submission

module load conda
conda activate agat-1.4.1

# set base and result directory
BASE=/lisc/scratch/zoology/pycnogonum/genome/draft/annot_merge
RESULT=/lisc/scratch/zoology/pycnogonum/genome/submission

# first gather the various input sources
ISOSEQ=$BASE/isoseq.gff
BRAKER_R1=$BASE/braker.gff
BRAKER_R2=$BASE/braker2_unique_renamed_nocodon_intron.gff3
DENOVO=$BASE/denovo_txomes/overlap_translated.gff3
TRNASCAN=$BASE/../trnascan/trnascan.gff3
# Also add the g8324 gene as predicted by BRAKER3; manual inspection has determined that it should
# replace gene models PB.7650, at_DN0411, and at_DN0412
g8324=$BASE/g8324.gff3
# navigate to output directory
cd $RESULT || exit

# merge the GFF3 files
cat $ISOSEQ $BRAKER_R1 $BRAKER_R2 $DENOVO $TRNASCAN $g8324 > merged_mix.gff3

# remove the gene models for the 3 genes that are replaced by g8324
{ echo "PB.7650"; echo "at_DN0411"; echo "at_DN0412"; } > kill_list
agat_sp_filter_feature_from_kill_list.pl --gff merged_mix.gff3 --kill_list kill_list -p gene -o merged.gff3

# rename pseudochromosomes 54-59 to 52-57 to reflect decontamination
sed -i 's/pseudochrom_54/pseudochrom_52/g' merged.gff3
sed -i 's/pseudochrom_55/pseudochrom_53/g' merged.gff3
sed -i 's/pseudochrom_56/pseudochrom_54/g' merged.gff3
sed -i 's/pseudochrom_57/pseudochrom_55/g' merged.gff3
sed -i 's/pseudochrom_58/pseudochrom_56/g' merged.gff3
sed -i 's/pseudochrom_59/pseudochrom_57/g' merged.gff3

# sort the GFF3 file
module load genometools/
gt gff3 -tidy -retainids -o merged_sorted.gff3 -force merged.gff3
