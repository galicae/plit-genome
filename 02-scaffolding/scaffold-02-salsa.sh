#!/usr/bin/env bash
#
#SBATCH --job-name=pycno-salsa2
#SBATCH --cpus-per-task=1
#SBATCH --mem=25G
#SBATCH --time=2:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=nikolaos.papadopoulos@univie.ac.at
#SBATCH --output=/lisc/user/papadopoulos/log/pycno-scaf-salsa2-%j.out
#SBATCH --error=/lisc/user/papadopoulos/log/pycno-scaf-salsa2-%j.err

module load bedtools
module load conda
conda activate salsa2-2.3

ASSEMBLY="/lisc/scratch/zoology/pycnogonum/genome/flye_full/assembly.fasta"
LENGTH="/lisc/scratch/zoology/pycnogonum/genome/flye_full/assembly.fasta.fai"
GFA="/lisc/scratch/zoology/pycnogonum/genome/flye_full/assembly.gfa"
OUT="/lisc/scratch/zoology/pycnogonum/genome/flye_full/scaffold/salsa2/"
BAM="/lisc/scratch/zoology/pycnogonum/genome/flye_full/scaffold/asm_hic.sorted.bam"

mkdir -p "$OUT" || exit 1
cd "$TMPDIR" || exit 1

# echo "Converting BAM to BED"
# # convert final BAM file to BED format
# bedtools bamtobed -i $BAM > $BED
# # sort bed file by name
# sort -k 4 $BED > tmp && mv tmp $BED

echo "Running SALSA2"
run_pipeline.py -a $ASSEMBLY -l $LENGTH -b $BAM -o $OUT -g $GFA -e DNASE -s 600 -m yes -p yes