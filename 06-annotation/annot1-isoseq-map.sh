#!/usr/bin/env bash
#
#SBATCH --job-name=mmap_pycno
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=15G
#SBATCH --time=15:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=nikolaos.papadopoulos@univie.ac.at
#SBATCH --output=/lisc/user/papadopoulos/log/pycno-mmap-%j.out
#SBATCH --error=/lisc/user/papadopoulos/log/pycno-mmap-%j.err

module load conda
conda activate minimap2-2.28

DRAFT=/lisc/scratch/zoology/pycnogonum/genome/draft/draft.fasta
ISOSEQ=/lisc/scratch/zoology/pycnogonum/genome/draft/transcriptome/isoseq/isoseq.fastq
/usr/bin/time minimap2 -ax splice -t16 -uf -C5 $DRAFT $ISOSEQ | samtools view -bS -o isoseq.bam