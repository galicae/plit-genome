#!/usr/bin/env bash
#
#SBATCH --job-name=mmseqs2-align
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=120G
#SBATCH --time=36:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=nikolaos.papadopoulos@univie.ac.at
#SBATCH --output=/lisc/user/papadopoulos/log/mmseqs-align-%j.out
#SBATCH --error=/lisc/user/papadopoulos/log/mmseqs-align-%j.err

module load mmseqs2

OUTPUT="/lisc/scratch/zoology/pycnogonum/genome/draft/contamination/"
UNIREF90="/lisc/scratch/zoology/db/uniref90/uniref90"

cd "$OUTPUT" || exit 1

mmseqs search asm $UNIREF90 contam "$TMPDIR" --threads 32 --search-type 2 --split-memory-limit 90G
mmseqs addtaxonomy $UNIREF90 contam contam_tax --threads 32 --lca-ranks kingdom
mmseqs createtsv asm $UNIREF90 contam_tax contam_tax.m8 --threads 32