#!/usr/bin/env bash
#
#SBATCH --job-name=jellyfish_pycno
#SBATCH --cpus-per-task=16
#SBATCH --mem=50G
#SBATCH --time=3:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=nikolaos.papadopoulos@univie.ac.at
#SBATCH --output=/home/user/papadopoulos/log/pycno-pre-jf-%j.out
#SBATCH --error=/home/user/papadopoulos/log/pycno-pre-jf-%j.err

module load jellyfish/2.3.0

k=$1
PACBIO="/scratch/zoology/pycnogonum/raw/m64120_240312_152428.ccs.fasta"
OUTPUT="/scratch/zoology/pycnogonum/genome/pb-jellyfish-k$k.res"

cd "$TMPDIR" || exit 1

jellyfish count -C -m "$k" -s 1000000000 -t 16 $PACBIO -o reads.jf
jellyfish histo -t 16 reads.jf > "$OUTPUT"

# remove $TMPDIR
cd || exit 1
rm -rf "$TMPDIR"