#!/usr/bin/env bash
#
#SBATCH --job-name=flye_pycno
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=30
#SBATCH --mem=100G
#SBATCH --time=10:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=nikolaos.papadopoulos@univie.ac.at
#SBATCH --output=/lisc/user/papadopoulos/log/pycno-flye-%j.out
#SBATCH --error=/lisc/user/papadopoulos/log/pycno-flye-%j.err

module load conda
conda activate flye-2.9.2

NANOPORE="/lisc/scratch/zoology/pycnogonum/raw/20230601_0904_3C_PAK64436_4d39d6a6/basecalls/202306050/PAK64436_1_202306050.fastq.gz"
OUTPUT=/lisc/scratch/zoology/pycnogonum/genome/flye_full/

mkdir -p $OUTPUT

# Run Flye
flye --nano-raw $NANOPORE \
--threads 30 \
--out-dir $OUTPUT
