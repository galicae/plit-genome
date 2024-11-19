#!/usr/bin/env bash
#
#SBATCH --job-name=flye_hifiasm
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=50G
#SBATCH --time=16:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=nikolaos.papadopoulos@univie.ac.at
#SBATCH --output=/lisc/user/papadopoulos/log/pycno-hifiasm-%j.out
#SBATCH --error=/lisc/user/papadopoulos/log/pycno-hifiasm-%j.err

module load hifiasm/0.19.8

HIFI="/lisc/scratch/zoology/pycnogonum/raw/m64120_240312_152428.ccs.fasta"
# NANOPORE="/lisc/scratch/zoology/pycnogonum/raw/20230601_0904_3C_PAK64436_4d39d6a6/basecalls/202306050/PAK64436_1_202306050.fastq.gz"
# OMNIC_R1="/lisc/scratch/zoology/pycnogonum/raw/omniC/DTG_OmniC_1016_R1.fastq"
# OMNIC_R2="/lisc/scratch/zoology/pycnogonum/raw/omniC/DTG_OmniC_1016_R2.fastq"
OUTPUT=/lisc/scratch/zoology/pycnogonum/genome/hifiasm/

mkdir -p $OUTPUT

hifiasm -o $OUTPUT/asm -t32 --primary $HIFI