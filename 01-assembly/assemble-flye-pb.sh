#!/usr/bin/env bash
#
#SBATCH --job-name=flye_pycno
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=50G
#SBATCH --time=10:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=nikolaos.papadopoulos@univie.ac.at
#SBATCH --output=/lisc/user/papadopoulos/log/pycno-flye-%j.out
#SBATCH --error=/lisc/user/papadopoulos/log/pycno-flye-%j.err

module load conda
conda activate flye-2.9.5

HIFI="/lisc/scratch/zoology/pycnogonum/raw/m64120_240312_152428.ccs.fasta"
OUTPUT=/lisc/scratch/zoology/pycnogonum/genome/flye_pb/

mkdir -p $OUTPUT

# Run Flye
flye --pacbio-hifi $HIFI \
--threads 16 \
--out-dir $OUTPUT
