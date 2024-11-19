#!/usr/bin/env bash
#
#SBATCH --job-name=shasta_pycno
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=48
#SBATCH --mem=200G
#SBATCH --time=5:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=nikolaos.papadopoulos@univie.ac.at
#SBATCH --output=/lisc/user/papadopoulos/log/pycno-shasta-%j.out
#SBATCH --error=/lisc/user/papadopoulos/log/pycno-shasta-%j.err

SHASTA=/lisc/user/papadopoulos/bin/shasta-Linux-0.11.1

NANOPORE="/lisc/scratch/zoology/pycnogonum/raw/20230601_0904_3C_PAK64436_4d39d6a6/basecalls/202306050/nanopore.fasta" # long read input
OUTPUT="/lisc/scratch/zoology/pycnogonum/genome/shasta_full/" # output directory

# run shasta
$SHASTA --input $NANOPORE --assemblyDirectory $OUTPUT --threads 48 --config Nanopore-R10-Fast-Nov2022

rm -rf "$TMPDIR"