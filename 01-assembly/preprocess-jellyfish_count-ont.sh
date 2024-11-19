#!/usr/bin/env bash
#
#SBATCH --job-name=jellyfish_pycno
#SBATCH --cpus-per-task=16
#SBATCH --mem=75G
#SBATCH --time=1:30:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=nikolaos.papadopoulos@univie.ac.at
#SBATCH --output=/lisc/user/papadopoulos/log/pycno-pre-jf-%j.out
#SBATCH --error=/lisc/user/papadopoulos/log/pycno-pre-jf-%j.err

module load jellyfish/2.3.0

k=$1
NANOPORE="/lisc/scratch/zoology/pycnogonum/raw/20230601_0904_3C_PAK64436_4d39d6a6/basecalls/202306050/nanopore.fasta"
OUTPUT="/lisc/scratch/zoology/pycnogonum/genome/ont-jellyfish-k$k.res"

cd "$TMPDIR" || exit 1

jellyfish count -C -m "$k" -s 1000000000 -t 16 $NANOPORE -o reads.jf
jellyfish histo -t 16 reads.jf > "$OUTPUT"

# remove $TMPDIR
cd "$OUTPUT" || exit 1
rm -rf "$TMPDIR"