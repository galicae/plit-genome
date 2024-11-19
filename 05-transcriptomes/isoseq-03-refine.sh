#!/usr/bin/env bash

#SBATCH --job-name=pb-refine
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=1G
#SBATCH --time=10:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=nikolaos.papadopoulos@univie.ac.at
#SBATCH --output=/lisc/user/papadopoulos/log/pycno-isoseq-refine-%j.out
#SBATCH --error=/lisc/user/papadopoulos/log/pycno-isoseq-refine-%j.err

module load conda
conda activate isoseq3-4.0.0

PACBIO="/lisc/scratch/zoology/pycnogonum/raw/r64046_20240215_071715_C02/processed"
BARCODES=/lisc/user/papadopoulos/repos/pycno-seq/dev_transcriptomes/barcodes.fasta

cd "$TMPDIR" || exit

DEMUX=$PACBIO/fl.thylaeodus_NEB_5p--NEB_Clontech_3p.bam
FLNC=$PACBIO/flnc.thylaeodus.bam
isoseq refine "$DEMUX" "$BARCODES" "$FLNC" --num-threads 32 --log-level INFO --log-file "$FLNC".report.txt --require-polya

DEMUX=$PACBIO/fl.scutopus_NEB_5p--NEB_Clontech_3p.bam
FLNC=$PACBIO/flnc.scutopus.bam
isoseq refine "$DEMUX" "$BARCODES" "$FLNC" --num-threads 32 --log-level INFO --log-file "$FLNC".report.txt --require-polya

DEMUX=$PACBIO/fl.pycnogonum_NEB_5p--NEB_Clontech_3p.bam
FLNC=$PACBIO/flnc.pycnogonum.bam
isoseq refine "$DEMUX" "$BARCODES" "$FLNC" --num-threads 32 --log-level INFO --log-file "$FLNC".report.txt --require-polya

# DEMUX=$PACBIO/fl.pycnogonum_NEB_5p--NEB_Clontech_3p.bam
# FLNC=$PACBIO/flnc.pycnogonum-nopolyA.bam
# isoseq refine "$DEMUX" "$BARCODES" "$FLNC" --num-threads 32 --log-level INFO --log-file "$FLNC".report.txt