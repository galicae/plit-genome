#!/usr/bin/env bash

#SBATCH --job-name=pb-demux
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=500M
#SBATCH --time=5:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=nikolaos.papadopoulos@univie.ac.at
#SBATCH --output=/lisc/user/papadopoulos/log/pycno-isoseq-demux-%j.out
#SBATCH --error=/lisc/user/papadopoulos/log/pycno-isoseq-demux-%j.err

module load conda
conda activate lima-2.9.0

PACBIO="/lisc/scratch/zoology/pycnogonum/raw/r64046_20240215_071715_C02/"
CCS=$PACBIO/ccs.bam
BARCODES=/lisc/user/papadopoulos/repos/pycno-seq/dev_transcriptomes/barcodes.fasta
DEMUX=$PACBIO/fl.bam

cd "$TMPDIR" || exit

# demultiplex CCS reads with lima
lima "$CCS" "$BARCODES" "$DEMUX" --isoseq --peek-guess --num-threads 32 --log-level INFO --log-file "$DEMUX".report.txt