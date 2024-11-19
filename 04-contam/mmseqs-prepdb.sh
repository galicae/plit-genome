#!/usr/bin/env bash
#
#SBATCH --job-name=mmseqs2-index
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=10G
#SBATCH --time=10:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=nikolaos.papadopoulos@univie.ac.at
#SBATCH --output=/lisc/user/papadopoulos/log/mmseqs-prep-%j.out
#SBATCH --error=/lisc/user/papadopoulos/log/mmseqs-prep-%j.err

module load mmseqs2

OUTPUT="/lisc/scratch/zoology/pycnogonum/genome/draft/contamination"
ASSEMBLY="/lisc/scratch/zoology/pycnogonum/genome/draft/GAP_sort_scaffolds_by_hic_insert/output/assembly/plit_q_0_50000_0.5FracBest_output.fasta"

mkdir -p "$OUTPUT" || exit 1
cd "$OUTPUT" || exit 1

mmseqs createdb $ASSEMBLY $OUTPUT/asm
mmseqs createindex $OUTPUT/asm "$TMPDIR" --threads 8 --search-type 2