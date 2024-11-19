#!/usr/bin/env bash

#SBATCH --job-name=pb-consensus
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=64
#SBATCH --mem=5G
#SBATCH --time=5:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=nikolaos.papadopoulos@univie.ac.at
#SBATCH --output=/lisc/user/papadopoulos/log/pycno-isoseq-ccs-%j.out
#SBATCH --error=/lisc/user/papadopoulos/log/pycno-isoseq-ccs-%j.err

module load conda
conda activate pbccs-6.4.0

PACBIO="/lisc/scratch/zoology/pycnogonum/raw/r64046_20240215_071715_C02/"
SUBREADS=$PACBIO/m64046_240218_003256.subreads.bam
CCS=$PACBIO/ccs.bam

cd "$TMPDIR" || exit

# generate CCS reads
# use the MIMALLOC env proposed by the pbccs documentation
MIMALLOC_PAGE_RESET=0 MIMALLOC_LARGE_OS_PAGES=1 ccs "$SUBREADS" "$CCS" --num-threads 64 --log-level INFO --report-file "$CCS".report.txt