#!/usr/bin/env bash

#SBATCH --job-name=pb-align
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=5
#SBATCH --mem=10G
#SBATCH --time=10:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=nikolaos.papadopoulos@univie.ac.at
#SBATCH --output=/lisc/user/papadopoulos/log/pycno-isoseq-align-%j.out
#SBATCH --error=/lisc/user/papadopoulos/log/pycno-isoseq-align-%j.err

module load conda

# input
PACBIO="/lisc/scratch/zoology/pycnogonum/raw/r64046_20240215_071715_C02/processed"
DRAFT="/lisc/scratch/zoology/pycnogonum/genome/draft/draft_softmasked.fasta"
FLNC=$PACBIO/flnc.pycnogonum.bam
TRANSCRIPTS=$PACBIO/clustered.pycnogonum.bam

# output
MAPPED="/lisc/scratch/zoology/pycnogonum/transcriptome/isoseq/mapped.bam"
GFF="/lisc/scratch/zoology/pycnogonum/transcriptome/isoseq/collapsed.gff"

cd "$TMPDIR" || exit

conda activate pacbio
pbmm2 align --preset ISOSEQ --sort -j 16 -J 4 -m 1200M --log-level INFO $TRANSCRIPTS $DRAFT $MAPPED
conda deactivate

conda activate isoseq3-4.0.0
isoseq collapse --do-not-collapse-extra-5exons --log-level INFO -j 32 $MAPPED $FLNC $GFF
conda deactivate