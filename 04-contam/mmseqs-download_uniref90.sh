#!/usr/bin/env bash
#
#SBATCH --job-name=uniref90
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=50G
#SBATCH --time=1:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=nikolaos.papadopoulos@univie.ac.at
#SBATCH --output=/lisc/user/papadopoulos/log/mmseqs-uniref90-%j.out
#SBATCH --error=/lisc/user/papadopoulos/log/mmseqs-uniref90-%j.err

module load mmseqs2

OUTPUT="/lisc/scratch/zoology/db/uniref90/"

mkdir -p "$OUTPUT" || exit 1
cd "$OUTPUT" || exit 1

mmseqs databases UniRef90 "$OUTPUT"/uniref90 "$TMPDIR" --threads 16