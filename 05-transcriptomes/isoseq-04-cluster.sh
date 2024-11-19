#!/usr/bin/env bash

#SBATCH --job-name=pb-cluster
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=20G
#SBATCH --time=60:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=nikolaos.papadopoulos@univie.ac.at
#SBATCH --output=/lisc/user/papadopoulos/log/pycno-isoseq-cluster-%j.out
#SBATCH --error=/lisc/user/papadopoulos/log/pycno-isoseq-cluster-%j.err

module load conda
# conda activate isoseq3-4.0.0

PACBIO="/lisc/scratch/zoology/pycnogonum/raw/r64046_20240215_071715_C02/processed"

cd "$TMPDIR" || exit

FLNC=$PACBIO/flnc.thylaeodus.bam
TRANSCRIPTS=$PACBIO/clustered.thylaeodus.bam
isoseq cluster2 "$FLNC" "$TRANSCRIPTS" --num-threads 32 --log-level INFO

FLNC=$PACBIO/flnc.scutopus.bam
TRANSCRIPTS=$PACBIO/clustered.scutopus.bam
isoseq cluster2 "$FLNC" "$TRANSCRIPTS" --num-threads 32 --log-level INFO

FLNC=$PACBIO/flnc.pycnogonum.bam
TRANSCRIPTS=$PACBIO/clustered.pycnogonum.bam
isoseq cluster2 "$FLNC" "$TRANSCRIPTS" --num-threads 32 --log-level INFO


# now convert the clustered BAM files to FASTA
conda activate pacbio

TRANSCRIPTS=$PACBIO/clustered.thylaeodus.bam
bam2fasta -o $PACBIO/thylaeodus_isoseq --num-threads 32 "$TRANSCRIPTS"
TRANSCRIPTS=$PACBIO/clustered.scutopus.bam
bam2fasta -o $PACBIO/scutopus_isoseq --num-threads 32 "$TRANSCRIPTS"
TRANSCRIPTS=$PACBIO/clustered.pycnogonum.bam
bam2fasta -o $PACBIO/pycnogonum_isoseq --num-threads 32 "$TRANSCRIPTS"