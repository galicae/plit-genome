#!/usr/bin/env bash
#
#SBATCH --cpus-per-task=16
#SBATCH --mem=50G
#SBATCH --time=48:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=nikolaos.papadopoulos@univie.ac.at
#SBATCH --output=/lisc/user/papadopoulos/log/%x-%j.out
#SBATCH --error=/lisc/user/papadopoulos/log/%x-%j.err

module load assembly/trinityrnaseq/2.15.1

R1=$1
R2=$2
ASSEMBLY=$3

mkdir -p "$ASSEMBLY" || exit 1

Trinity \
 --seqType fq \
 --max_memory 50G \
 --trimmomatic \
 --no_salmon \
 --output "$ASSEMBLY" \
 --CPU 16 \
 --left "$R1" \
 --right "$R2"