#!/usr/bin/env bash
#
#SBATCH --job-name=canu_pycno
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=30
#SBATCH --mem=100G
#SBATCH --time=48:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=nikolaos.papadopoulos@univie.ac.at
#SBATCH --output=/lisc/user/papadopoulos/log/pycno-canu-%j.out
#SBATCH --error=/lisc/user/papadopoulos/log/pycno-canu-%j.err

module load assembly/canu/2.2

# long read input
NANOPORE="/lisc/scratch/zoology/pycnogonum/raw/20230601_0904_3C_PAK64436_4d39d6a6/basecalls/202306050/PAK64436_1_202306050.fastq.gz"

# output directory
OUTPUT="/lisc/scratch/zoology/pycnogonum/genome/canu_full/"
mkdir -p "$OUTPUT" || exit 1

# go to $TMPDIR
cd "$TMPDIR" || exit 1

# run canu
canu \
 -p ecoli \
 -d ecoli-oxford \
 genomeSize=550m \
 maxMemory=100g \
 maxThreads=30 \
 minReadLength=500 \
 fast=true \
 -nanopore $NANOPORE

# copy all the relevant output to the output directory
cp -r "$TMPDIR"/ "$OUTPUT"

# remove $TMPDIR
cd "$OUTPUT" || exit 1
rm -rf "$TMPDIR"