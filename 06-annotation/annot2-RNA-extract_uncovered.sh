#!/usr/bin/env bash
#
#SBATCH --job-name=extr_unannot
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=2G
#SBATCH --time=2:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=nikolaos.papadopoulos@univie.ac.at
#SBATCH --output=/lisc/user/papadopoulos/log/pycno-subset_bam-%j.out
#SBATCH --error=/lisc/user/papadopoulos/log/pycno-subset_bam-%j.err

module load bedtools

GFF=/lisc/scratch/zoology/pycnogonum/genome/draft/annot_merge/merged.gff3
OUTPUT=$1
cd "$OUTPUT" || exit

bedtools intersect -v -a Aligned.out.bam -b $GFF > unannotated.bam