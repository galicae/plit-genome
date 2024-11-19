#!/usr/bin/env bash
#
#SBATCH --job-name=converter
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=100M
#SBATCH --time=90:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=nikolaos.papadopoulos@univie.ac.at
#SBATCH --output=/lisc/user/papadopoulos/log/pycno-sam2bam-%j.out
#SBATCH --error=/lisc/user/papadopoulos/log/pycno-sam2bam-%j.err

module load samtools

INPUT=$1
BASENAME=$(dirname "$INPUT")
OUTPUT=$BASENAME/Aligned.out.bam

samtools view -bSh --threads 4 "$INPUT" > "$OUTPUT"