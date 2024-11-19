#!/usr/bin/env bash
#
#SBATCH --job-name=converter
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=6
#SBATCH --mem=16G
#SBATCH --time=15:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=nikolaos.papadopoulos@univie.ac.at
#SBATCH --output=/lisc/user/papadopoulos/log/pycno-indexbam-%j.out
#SBATCH --error=/lisc/user/papadopoulos/log/pycno-indexbam-%j.err

module load samtools

INPUT=$1
BASENAME=$(dirname "$INPUT")
OUTPUT=$BASENAME/Aligned.out.sorted.bam

cd "$TMPDIR" || exit
samtools sort -@ 8 "$INPUT" > "$OUTPUT"
samtools index -@ 8 -b "$OUTPUT"